json.array!(@example_tests) do |example_test|
  json.extract! example_test, :id, :name
  json.url example_test_url(example_test, format: :json)
end
