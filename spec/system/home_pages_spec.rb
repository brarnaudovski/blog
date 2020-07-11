require 'rails_helper'

RSpec.describe "HomePages" do
  before do
    driven_by :selenium, using: :chrome
    # driven_by :rack_test

    visit root_path
  end

  it 'shows the home link' do
    expecting = page.has_link?('My Blog')

    expect(expecting).to be true
  end

  context 'when no user is sign in' do
    it 'shows the Log In link' do
      expecting = page.has_link?('Log In')

      expect(expecting).to be true
    end

    it 'shows the Sign Up link' do
      expecting = page.has_link?('Sign Up')

      expect(expecting).to be true
    end
  end

  context 'when user is sign in into the app' do
    before do
      log_in(create(:user))
      visit root_path
    end

    it 'shows the New Article link' do
      expecting = page.has_link?('New Article')

      expect(expecting).to be true
    end

    it 'shows the Log Out link' do
      expecting = page.has_link?('Log Out')

      expect(expecting).to be true
    end
  end

  context 'when an article is present' do
    let!(:article) { create(:article, title: 'Testing with RSpec', body: 'Testing article body') }

    before do
      visit root_path
    end

    it 'shows the article title' do
      expecting = page.has_content?(article.title)

      expect(expecting).to be true
    end

    it 'shows the article body' do
      expecting = page.has_content?(article.body)

      expect(expecting).to be true
    end

    it 'shows the link to article' do
      expecting = page.has_link?('Show')

      expect(expecting).to be true
    end
  end
end
