# coding: utf-8
FactoryGirl.define do
  sequence(:random_string) {|n| Digest::MD5.hexdigest(n.to_s) }
  sequence(:random_email) {|n| "#{n}@example.com" }
  sequence(:count)
end
