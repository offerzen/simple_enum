require 'test_helper'

class DirtyDummy < ActiveRecord::Base
  set_table_name 'dummies'
  as_enum :gender, [:male, :female], :dirty => true
end

class DirtyAttributesTest < ActiveSupport::TestCase
  def setup
    reload_db
  end

  test "setting using changed? on enum" do
    jane = DirtyDummy.create!(:gender => :female)
    assert_equal 1, jane.gender_cd
    jane.gender = :male # operation? =)
    assert_equal :male, jane.gender
    assert_equal true, jane.gender_cd_changed?
    assert_equal true, jane.gender_changed?
  end

  test "access old value via gender_was" do
    john = DirtyDummy.create!(:gender => :male)
    assert_equal 0, john.gender_cd
    john.gender = :female
    assert_equal :female, john.gender
    assert_equal 0, john.gender_cd_was
    assert_equal :male, john.gender_was
  end

  test "dirty methods are disabled by default (opt-in)" do
    no_dirty = Dummy.new
    assert !no_dirty.respond_to?(:gender_was), "should not respond_to :gender_was"
    assert !no_dirty.respond_to?(:gender_changed?), "should not respond_to :gender_changed?"
    assert !no_dirty.respond_to?(:word_was), "should not respond_to :word_was"
    assert !no_dirty.respond_to?(:word_changed?), "should not respond_to :word_changed?"
  end
end