require 'rails_helper'

RSpec.describe Ci::Build, type: :model do
  describe '#archive_trace!' do
    subject(:ci_build) { create(:ci_build) }

    it 'moves trace log from build directory to artifacts directory' do
    end
  end
end
