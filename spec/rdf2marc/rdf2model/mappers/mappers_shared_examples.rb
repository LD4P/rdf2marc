# frozen_string_literal: true

RSpec.shared_examples 'mapper' do |mapper_class|
  # rubocop:disable RSpec/SubjectDeclaration
  let(:subject) { mapper_class.new(context) }
  # rubocop:enable RSpec/SubjectDeclaration

  let(:context) do
    Rdf2marc::Rdf2model.item_context_for(graph, RDF::URI(instance_term), RDF::URI(work_term),
                                         RDF::URI(admin_metadata_term))
  end

  let(:instance_term) { 'https://api.sinopia.io/resource/test_instance' }

  let(:work_term) { 'https://api.sinopia.io/resource/test_work' }

  let(:admin_metadata_term) { 'https://api.sinopia.io/resource/test_admin_metadata' }

  let(:graph) { RDF::Graph.new.from_ttl(ttl) }

  it 'maps to model' do
    # puts subject.generate.deep_compact
    expect(subject.generate.deep_compact).to eq model
  end
end
