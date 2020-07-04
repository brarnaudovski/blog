FactoryBot.define do
  factory :comment do
    user
    article
    
    body { 'Some comment!!' }
  end
end
