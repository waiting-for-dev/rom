module ROM
  class Adapter
    module Lint
      module TestAdapter
        attr_reader :adapter

        def test_schemes
          assert_instance_of Array, adapter.schemes,
            "#{adapter}.schemes must return an array with supported URI schemes"

          assert adapter.schemes.size > 0,
            "#{adapter}.schemes must return at least one supported URI scheme"
        end

        def test_setup
          assert_instance_of adapter, adapter_instance
        end

        def test_dataset_reader
          assert_respond_to adapter_instance, :[]
        end

        def test_dataset_predicate
          assert_respond_to adapter_instance, :dataset?
        end

        private

        def adapter_instance
          Adapter.setup("#{adapter.schemes.first}://localhost/test")
        end
      end

      module TestEnumerableDataset
        attr_reader :dataset, :data

        def test_each
          result = []
          dataset.each { |tuple| result << tuple }
          assert_equal result, data
        end

        def test_to_a
          assert_equal dataset.to_a, data
        end

        def test_find_all
          block = -> tuple { tuple[:name] == 'Jane' }

          expected = data.find_all(&block)
          result = dataset.find_all(&block)

          assert_instance_of dataset.class, result
          assert_equal expected, result.to_a
        end
      end
    end
  end
end
