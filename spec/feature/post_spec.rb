require 'spec_helper'

RSpec.feature "CRUD Post", type: :feature do
  describe "index" do
    before do
      @post_title = "Index post"
      @post_content = "SiliconJungles"
      visit 'http://localhost:3000'
      click_link('New Post')
      within("form") do
        fill_in 'Title', with: @post_title
        fill_in 'Content', with: @post_content
      end
      click_button("Create Post")
    end
    
    it "should returns all posts" do
      visit 'http://localhost:3000'
      expect(page).to have_content 'Posts'
      expect(page).to have_content @post_content
      expect(page).to have_content @post_title
    end
  end

  describe "new" do
    context "with valid information" do
      it "should returns a new post" do
        visit 'http://localhost:3000'
        click_link('New Post')
        within("form") do
          fill_in 'Title', with: 'New post'
          fill_in 'Content', with: 'SiliconJungles'
        end
        click_button("Create Post")
        expect(page).to have_content "Post was successfully created."
        expect(page).to have_content "New post"
        expect(page).to have_content "SiliconJungles"
      end
    end

    context "with invalid information" do
      it "should returns error" do
        visit 'http://localhost:3000'
        click_link('New Post')
        within("form") do
          fill_in 'Title', with: ''
          fill_in 'Content', with: ''
        end
        click_button("Create Post")
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Content can't be blank"
      end
    end
  end

  describe "update" do
    before do
      @post_title = "First post"
      @post_content = "SiliconJungles"
      visit 'http://localhost:3000'
      click_link('New Post')
      within("form") do
        fill_in 'Title', with: @post_title
        fill_in 'Content', with: @post_content
      end
      click_button("Create Post")
    end

    context "with valid input" do
      it "should update a post" do
        visit 'http://localhost:3000'
        click_link("Edit")
        within("form") do
          fill_in 'Title', with: 'Second Post'
          fill_in 'Content', with: 'SiliconAvengers'
        end
        click_button("Update Post")
        expect(page).to have_content "Post was successfully updated."
        expect(page).to have_content "Second Post"
        expect(page).to have_content "SiliconAvengers"
      end
    end

    context "with invalid input" do
      it "should returns error" do
        visit 'http://localhost:3000'
        click_link("Edit")
        within("form") do
          fill_in 'Title', with: ''
          fill_in 'Content', with: ''
        end
        click_button("Update Post")
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Content can't be blank"
      end
    end
  end

  describe "delete" do
    before do
      @post_title = "First post"
      @post_content = "SiliconJungles"
      visit 'http://localhost:3000'
      click_link('New Post')
      within("form") do
        fill_in 'Title', with: @post_title
        fill_in 'Content', with: @post_content
      end
      click_button("Create Post")
    end

    it "should delete the post", js: true do
      visit 'http://localhost:3000'
      first('a[data-method="delete"]').click
      page.accept_alert
      expect(page).to have_content "Post was successfully destroyed."
    end
  end
end