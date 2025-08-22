defmodule LlmFromScratch.SimpleTokenizerV2 do
  @moduledoc """
  A simple tokenizer that splits text into words based on whitespace and punctuation.
  It provides functions to create a vocabulary, encode text into integer IDs, and decode integer IDs back into words.
  This version uses a different regex pattern for splitting text.
  """

  @spec vocabulary(String.t()) :: %LlmFromScratch.Vocabulary{}
  def vocabulary(text) when is_binary(text) do
    text
    |> String.split(~r/[,.:;?_!"()\']|--|\s/, [include_captures: true, trim: true])
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 == ""))
    |> Stream.uniq()
    |> Enum.sort()
    |> Enum.concat(["<|endoftext|>", "<|unk|>"])  # Adding a special token for unknown words
    |> Enum.with_index()
    |> Enum.reduce(%LlmFromScratch.Vocabulary{str_to_int: %{}, int_to_str: %{}}, fn {word, index}, acc ->
      %LlmFromScratch.Vocabulary{
        str_to_int: Map.put(acc.str_to_int, word, index),
        int_to_str: Map.put(acc.int_to_str, index, word)
      }
    end)
  end

  @doc """
  Encodes a given text into a list of integer IDs based on the provided vocabulary.
  """
  @spec encode(String.t(), %LlmFromScratch.Vocabulary{}) :: list(integer)
  def encode(text, vocabulary) when is_binary(text) do
    text
    |> String.split(~r/[,.:;?_!"()\']|--|\s/, [include_captures: true, trim: true])
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 == ""))
    |> Enum.map(&Map.get(vocabulary.str_to_int, &1, Map.get(vocabulary.str_to_int, "<|unk|>")))
  end

  @doc """
  Decodes a list of integer IDs back into their corresponding words using the provided vocabulary.
  """
  @spec decode([integer], %LlmFromScratch.Vocabulary{}) :: list(String.t())
  def decode(ids, vocabulary) when is_list(ids) do
    ids
    |> Enum.map(&Map.get(vocabulary.int_to_str, &1))
    |> Enum.reject(&(&1 == nil))
  end
end
