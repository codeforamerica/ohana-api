require 'rails_helper'

describe Api::V1::BlogPostsController do
  describe 'GET #index' do
    it 'responds with the list of all blog posts' do
      create(:blog_post, :soccer)
      get :index
      expect(BlogPost.count).to eq(1)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.first['title']).to eq('Test Blog post')
      expect(parsed_response.first['image_legend']).to eq('Test image legend')
    end

    it 'responds with blog posts filtred by category' do
      create(:blog_post, :soccer)
      new_blog = BlogPost.new(
        title: 'Second BlogPost',
        posted_at: '2019-01-06 18:30:00',
        body: 'Los Angeles',
        is_published: false,
        admin_id: 1
      )
      new_blog.category_list.add('food')
      new_blog.save
      get :index, filter: { category: 'food' }
      expect(BlogPost.count).to eq(2)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.size).to eq(1)
      expect(parsed_response.first['title']).to eq('Second BlogPost')
      expect(parsed_response.first['body']).to eq('Los Angeles')
      expect(parsed_response.first['is_published']).to eq(false)
      expect(parsed_response.first['categories'].first['name']).to eq('food')
    end

    it 'responds with blog posts filtred by in draft state' do
      create(:blog_post, :soccer)
      new_blog = BlogPost.new(
        title: 'Second BlogPost',
        posted_at: '2019-01-06 18:30:00',
        body: 'Los Angeles',
        is_published: true,
        admin_id: 1
      )
      new_blog.save
      get :index, filter: { draft: true }
      expect(BlogPost.count).to eq(2)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.size).to eq(1)
      expect(parsed_response.first['title']).to eq('Test Blog post')
      expect(parsed_response.first['image_legend']).to eq('Test image legend')
      expect(parsed_response.first['is_published']).to eq(false)
    end
  end

  describe 'POST #create' do
    it 'creates a new blog post into database' do
      post :create, blog_post: {
        title: 'My BlogPost',
        posted_at: '2019-01-06 18:30:00',
        body: 'Los Angeles',
        is_published: false,
        admin_id: 1
      }
      expect(BlogPost.count).to eq(1)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['title']).to eq('My BlogPost')
      expect(parsed_response['body']).to eq('Los Angeles')
    end
  end

  describe 'PUT #update' do
    it 'updates an existing blog post' do
      blog_post = create(:blog_post)
      put :update, blog_post: {
        title: 'Updated BlogPost'
      }, id: blog_post.id
      expect(BlogPost.count).to eq(1)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['title']).to eq('Updated BlogPost')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes an existing blog post' do
      blog_post = create(:blog_post)
      expect(BlogPost.count).to eq(1)
      delete :destroy, id: blog_post.id
      expect(BlogPost.count).to eq(0)
    end
  end
end
