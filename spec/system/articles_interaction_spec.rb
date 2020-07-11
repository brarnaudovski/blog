require 'rails_helper'

RSpec.describe "ArticlesInteraction" do
  let(:user) { create(:user) }
  let(:article) { create(:article, user: user) }

  before do
    driven_by :selenium, using: :chrome
    # driven_by :rack_test

    log_in(user)
    # visit article_path(article)
  end

  describe 'Creating an article' do
    it 'creates and shows the newly created article' do
      title = 'Create new system spec'
      body = 'This is the body'

      click_on('New Article')

      within('form') do
        fill_in "Title", with: title
        fill_in "Body", with: body

        click_on 'Save Article'
      end

      expect(page).to have_content(title)
      expect(page).to have_content(body)
    end
  end

  describe 'Editing an article' do
    it 'edits and shows the article' do
      title = 'New Title'
      body = 'New Body'

      visit article_path(article)

      click_on 'Edit'

      within('form') do
        fill_in "Title", with: title
        fill_in "Body", with: body

        click_on 'Update Article'
      end

      expect(page).to have_content(title)
      expect(page).to have_content(body)
    end
  end

  describe 'Deleting an article' do
    it 'deletes the article and redirect to index view' do
      visit article_path(article)

      # Only if using selenium driver.
      # If not, comment this block
      accept_alert do
        click_on 'Delete'
      end

      # If using rack_test driver, uncomment this block
      # click_on 'Delete'

      expect(page).to have_content('Articles')
    end
  end

  describe 'Creating new article comments' do
    it 'creates an article comment' do
      new_comment = 'New comment'

      visit article_path(article)

      click_on 'New Comment'

      within('form') do
        fill_in 'comment_body', with: new_comment

        click_on 'Save'
      end

      expect(page).to have_content(new_comment)
    end
  end

  describe 'Going back to article index page' do
    it 'goes back to article index page' do
      visit article_path(article)

      click_on 'Back'

      expect(page).to have_content('Articles')
    end
  end
end
