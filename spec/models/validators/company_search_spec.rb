require 'rails_helper'

RSpec.describe Validators::CompanySearch, type: :model do

  let!(:params) {
    {
      name: "Company",
      min_employee_count: 100,
      industry: "tech",
      minimum_deal_amount: 200,
    }
  }
  describe "validations" do
    let(:subject) { described_class.new(params) }

    context "when params are correct" do
      it "will be valid" do
        expect(subject).to be_valid
      end
    end

    context "when params are not correct" do
      let!(:wrong_params) {
        {
          name: "@",
          min_employee_count: -1,
          industry: "@",
          minimum_deal_amount: -2,
        }
      }
    let(:not_valid_subject) { described_class.new(wrong_params) }

      it "will not be valid" do
        expect(not_valid_subject).not_to be_valid
        expect(not_valid_subject.errors.messages.keys).to eq [:name, :industry, :min_employee_count, :minimum_deal_amount]
        expect(not_valid_subject.errors.full_messages).to eq ["Name must contain only letters and numbers",
          "Industry must contain only letters and numbers",
          "Min employee count only allows positive numbers",
          "Minimum deal amount only allows positive numbers"]
      end
    end
  end
end
