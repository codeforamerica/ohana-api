require 'rails_helper'

describe Api::V1::BlogPostsController do
  describe 'GET #index' do
    it 'responds with the list of all blog posts' do
      create(:blog_post, :soccer)
      get :index
      expect(BlogPost.count).to eq(1)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.first['title']).to eq('Test Blog post')
    end

    it 'responds with blog posts filtred by category' do
      create(:blog_post, :soccer)
      new_blog = BlogPost.new(
        title: 'Second BlogPost',
        posted_at: '2019-01-06 18:30:00',
        body: 'Los Angeles',
        is_published: false,
        admin_id: 1,
        blog_post_attachments_attributes: [
          {
            file_type: 'video',
            file_url: 'test.com',
            file_legend: 'test test',
            order: 1,
          }
        ]
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
      expect(parsed_response.first['blog_post_attachments'].size).to eq(1)
      expect(parsed_response.first['blog_post_attachments'].first['file_type']).to eq('video')
      expect(parsed_response.first['blog_post_attachments'].first['file_url']).to eq('test.com')
      expect(parsed_response.first['blog_post_attachments'].first['file_legend']).to eq('test test')
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
      expect(parsed_response.first['is_published']).to eq(false)
    end
  end

  describe 'GET #show' do
    it 'responds with the info for an specific blog posts' do
      blog_posts = create(:blog_post, :soccer)
      get :show, id: blog_posts.id
      expect(BlogPost.count).to eq(1)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['title']).to eq('Test Blog post')
      expect(parsed_response['is_published']).to eq(false)
    end
  end

  describe 'POST #create' do
    it 'creates a new blog post into database' do
      post :create, blog_post: {
        title: 'My BlogPost',
        posted_at: '2019-01-06 18:30:00',
        body: 'Los Angeles',
        is_published: false,
        admin_id: 1,
        blog_post_attachments_attributes: [
          {
            file_type: 'video',
            file_url: 'test.com',
            file_legend: 'test test',
            order: 1,
          }
        ]
      }
      expect(BlogPost.count).to eq(1)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['title']).to eq('My BlogPost')
      expect(parsed_response['body']).to eq('Los Angeles')
      expect(parsed_response['blog_post_attachments'].first['file_type']).to eq('video')
      expect(parsed_response['blog_post_attachments'].first['file_legend']).to eq('test test')
    end
  end

  describe 'PUT #update' do
    it 'updates an existing blog post' do
      blog_post = create(:blog_post_with_attachment)
      put :update, blog_post: {
        title: 'Updated BlogPost',
        blog_post_attachments_attributes: [
          {
            id: blog_post.blog_post_attachments.first.id,
            file_legend: 'test test',
            order: 2
          }
        ]
      }, id: blog_post.id
      expect(BlogPost.count).to eq(1)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['title']).to eq('Updated BlogPost')
      expect(parsed_response['blog_post_attachments'].first['file_legend']).to eq('test test')
      expect(parsed_response['blog_post_attachments'].first['order']).to eq(2)
    end

    it 'deletes an existing blog post attachment' do
      blog_post = create(:blog_post_with_attachment)
      expect(BlogPost.count).to eq(1)
      expect(blog_post.blog_post_attachments.size).to eq(1)
      put :update, blog_post: {
        blog_post_attachments_attributes: [
          {
            id: blog_post.blog_post_attachments.first.id,
            _destroy: true
          }
        ]
      }, id: blog_post.id
      expect(blog_post.blog_post_attachments.size).to eq(0)
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

  describe 'GET #categories' do
    it 'responds with the list of all blog posts categories' do
      new_blog = BlogPost.new(
        title: 'Second BlogPost',
        posted_at: '2019-01-06 18:30:00',
        body: 'Los Angeles',
        is_published: false,
        admin_id: 1,
        blog_post_attachments_attributes: [
          {
            file_type: 'video',
            file_url: 'test.com',
            file_legend: 'test test',
            order: 1,
          }
        ]
      )
      new_blog.category_list.add('food')
      new_blog.save

      second_blog = BlogPost.new(
        title: 'Third BlogPost',
        posted_at: '2019-01-06 18:30:00',
        body: 'Los Angeles',
        is_published: false,
        admin_id: 1,
        blog_post_attachments_attributes: [
          {
            file_type: 'video',
            file_url: 'test.com',
            file_legend: 'test test',
            order: 1,
          }
        ]
      )
      second_blog.category_list.add('games')
      second_blog.save

      get :categories

      expect(BlogPost.count).to eq(2)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.first['name']).to eq('food')
      expect(parsed_response.second['name']).to eq('games')
    end
  end
end
