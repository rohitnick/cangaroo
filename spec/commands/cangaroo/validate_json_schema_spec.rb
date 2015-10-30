require 'rails_helper'

module Cangaroo
  RSpec.describe ValidateJsonSchema do
    let(:command) { ValidateJsonSchema.new(body) }

    describe '#call' do
      before do
        command.call
      end

      context 'when json is well formatted' do
        let(:body) { load_json('json_payload_ok') }

        it 'returns true' do
          expect(command.result).to be true
        end
      end

      context 'when json is not well formatted' do
        describe 'with wrong main key' do
          let(:body) { load_json('json_payload_wrong_key') }

          it 'returns false' do
            expect(command.result).to be false
          end

          it 'fails' do
            expect(command).to be_failure
          end

          it 'adds an error' do
            expect(command.errors[:schema_error]).not_to be_empty
          end
        end

        describe 'without an object id' do
          let(:body) { load_json('json_payload_no_id') }

          it 'returns false' do
            expect(command.result).to be false
          end

          it 'fails' do
            expect(command).to be_failure
          end

          it 'adds an error' do
            expect(command.errors[:schema_error]).not_to be_empty
          end
        end

      end
    end
  end
end
