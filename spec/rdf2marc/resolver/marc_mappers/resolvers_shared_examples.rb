# frozen_string_literal: true

RSpec.shared_examples 'resolver_mapper' do |mapper_class, tag, model_class|
  # rubocop:disable RSpec/SubjectDeclaration
  let(:subject) { mapper.map.deep_compact }
  # rubocop:enable RSpec/SubjectDeclaration

  let(:mapper) { mapper_class.new(uri, marc_record) }

  let(:marc_record) do
    record = MARC::Record.new
    record.append(MARC::DataField.new(tag,
                                      defined?(indicator1) ? indicator1 : ' ',
                                      defined?(indicator2) ? indicator2 : ' ',
                                      *subfields))
    record
  end

  it 'maps to model' do
    # puts subject.generate.deep_compact
    expect(subject).to eq model

    # Validate with model class
    model_class.new(subject)
  end
end
