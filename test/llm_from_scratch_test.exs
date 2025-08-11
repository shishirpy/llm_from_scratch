defmodule LlmFromScratchTest do
  use ExUnit.Case
  doctest LlmFromScratch

  test "greets the world" do
    assert LlmFromScratch.hello() == :world
  end
end
