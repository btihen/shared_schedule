require 'rails_helper'

RSpec.describe CalendarView, type: :model do

  let(:subject)   { described_class.new(date: date) }

  context "Given a date get #month_name" do
    let(:date)    { Date.new(2010, 2, 10) }
    it "returns the full month name" do
      expect(subject.month_name).to eq ("February")
    end
  end

  context "Given a date get #year_number" do
    let(:date)    { Date.new(2010, 2, 10) }
    it "returns the four digit year" do
      expect(subject.month_name).to eq ("February")
    end
  end

  context "Given a date get #date_range" do
    describe "Feb 2010 (non-leap year) - start on a Monday and ends on a Sunday" do
      let(:date)    { Date.new(2010, 2, 10) }
      it "shows the correct 4 week range" do
        expect(subject.date_range).to eq (Date.new(2010, 2, 1)..Date.new(2010, 2, 28))
      end
    end
    describe "Jan 2010 - start on a Friday and ends on a Sunday" do
      let(:date)    { Date.new(2010, 1, 10) }
      it "shows the correct 5 week range" do
        expect(subject.date_range).to eq (Date.new(2009, 12, 28)..Date.new(2010, 1, 31))
      end
    end
    describe "Feb 2009 - starts on a Sunday and ends on a Saturday" do
      let(:date)    { Date.new(2009, 2, 10) }
      it "shows the correct 5 week range" do
        expect(subject.date_range).to eq (Date.new(2009, 1, 26)..Date.new(2009, 3, 1))
      end
    end
    describe "May 2010 - start on a Saturday and ends on a Monday" do
      let(:date)    { Date.new(2010, 5, 10) }
      it "shows the correct 6 week range" do
        expect(subject.date_range).to eq (Date.new(2010, 4, 26)..Date.new(2010, 6, 6))
      end
    end
  end

  context "Detect if #date_in_month_of_interest?" do
    describe "Feb of a non-leap year starting on a Monday ending on a Sunday" do
      let(:date)      { Date.new(2010, 2, 10) }
      it "Jan is out of range" do
        test_date = Date.new(2010, 1, 15)
        expect(subject.date_in_month_of_interest?(test_date)).to be_falsey
      end
      it "Feb is in range" do
        test_date = Date.new(2010, 2, 15)
        expect(subject.date_in_month_of_interest?(test_date)).to be_truthy
      end
      it "Mar is out of range" do
        test_date = Date.new(2010, 3, 15)
        expect(subject.date_in_month_of_interest?(test_date)).to be_falsey
      end
    end

    describe "May 2010 - with date range: (Date.new(2010, 4, 26)..Date.new(2010, 6, 6))" do
      let(:date)      { Date.new(2010, 5, 10) }
      it "May is in Range" do
        test_date = Date.new(2010, 5, 15)
        expect(subject.date_in_month_of_interest?(test_date)).to be_truthy
      end
      it "April 28 is in Range, but not the month of interest" do
        test_date = Date.new(2010, 4, 28)
        expect(subject.date_in_month_of_interest?(test_date)).to be_falsey
      end
      it "June 3 is in Range, but not the month of interest" do
        test_date = Date.new(2010, 6, 3)
        expect(subject.date_in_month_of_interest?(test_date)).to be_falsey
      end
    end
  end

end
