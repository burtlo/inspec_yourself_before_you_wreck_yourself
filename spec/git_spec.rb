require 'spec_helper'

describe_inspec_resource 'git' do

  context 'relying on the automatic path' do
    it 'has a version' do
      environment do
        command('git --version').returns(stdout: "")
      end

      expect(resource.version).to eq('14.8.10')
    end
  end
end
