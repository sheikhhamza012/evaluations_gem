require 'byebug'
RSpec.describe EvaluationsGem do
  it "has a version number" do
    expect(EvaluationsGem::VERSION).not_to be nil
  end

  it "checks error file" do
    EvaluationsGem::Evaluations.manager_to_collaborator('spec/file_e.xlsx')
    expected = RubyXL::Parser.parse('spec/expected_error.xlsx')
    output = RubyXL::Parser.parse('evaluators_error.xlsx')
    expected[0].each_with_index do |expected_val, i|

      rows= expected[0][0].size
      j=0
      while j<rows do
        expect(expected_val[j]&.value).to eq(output[0][i][j]&.value)
        j+=1
      end
      
    end
  end
  
  it "checks manager function" do
    EvaluationsGem::Evaluations.manager_to_collaborator('spec/file1.xlsx')
    expected = RubyXL::Parser.parse('spec/expected_manager.xlsx')
    output = RubyXL::Parser.parse('output_manager.xlsx')
    expected[0].each_with_index do |expected_val, i|

      rows= expected[0][0].size
      j=0
      while j<rows do
        expect(expected_val[j]&.value).to eq(output[0][i][j]&.value)
        j+=1
      end
      
    end
  end
  
  it "checks peer functions" do
    EvaluationsGem::Evaluations.peer_to_peer('spec/file1.xlsx')
    expected = RubyXL::Parser.parse('spec/expected_peers.xlsx')
    output = RubyXL::Parser.parse('output_peers.xlsx')
    expected[0].each_with_index do |expected_val, i|

      rows= expected[0][0].size
      j=0
      while j<rows do
        expect(expected_val[j]&.value).to eq(output[0][i][j]&.value)
        j+=1
      end
      
    end
  end

end
