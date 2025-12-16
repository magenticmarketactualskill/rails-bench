# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    @products = Product.order(id: :asc)
    render inertia: 'Products/Index', props: {
      products: @products.as_json(only: [:id, :sku, :name, :price, :category, :active])
    }
  end

  def show
    @product = Product.find(params[:id])
    render inertia: 'Products/Show', props: {
      product: @product.as_json(only: [:id, :sku, :name, :price, :category, :active])
    }
  end
end
