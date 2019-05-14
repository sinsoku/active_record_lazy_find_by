# frozen_string_literal: true

require "spec_helper"

RSpec.describe ActiveRecordLazyFindBy do
  describe ".module_for" do
    let(:mod) { ActiveRecordLazyFindBy.module_for(User, id: 1, name: "foo") }

    it { expect(mod.public_instance_methods).to match_array %i[age age? age= valid? new_record? persisted?] }
  end

  describe ".lazy_find_by" do
    before(:all) { User.create(id: 1, name: "dhh", age: 39) }

    context "when using only passed attributes" do
      it "does not execute sql" do
        user = User.lazy_find_by(id: 1, name: "foo")

        expect(user.id).to eq 1
        expect(user.name).to eq "foo"
      end
    end

    context "when using attributes that has not been passed" do
      it "returns the value after reloading db" do
        user = User.lazy_find_by(id: 1, name: "foo")

        expect(user.age).to eq 39
      end
    end
  end
end
