defmodule LlmFromScratch.Vocabulary do

  @moduledoc """
  A struct to hold the vocabulary mappings. It contains two maps:
  - `str_to_int`: Maps words (strings) to their corresponding integer IDs.
  - `int_to_str`: Maps integer IDs back to their corresponding words (strings).
  """
  @enforce_keys [:str_to_int, :int_to_str]
  @type t :: %__MODULE__{
          str_to_int: %{String.t() => integer},
          int_to_str: %{integer => String.t()}
        }
  defstruct str_to_int: %{}, int_to_str: %{}
end
