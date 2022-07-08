class AdminPublicBodyCategoriesController < AdminController

  include TranslatableParams

  before_action :set_public_body_category, :only => [:edit, :update, :destroy]

  def index
    @locale = AlaveteliLocalization.locale
    @category_headings = PublicBodyHeading.by_display_order
    @without_heading = PublicBodyCategory.without_headings
  end

  def new
    @public_body_category = PublicBodyCategory.new
    @public_body_category.build_all_translations
  end

  def create
    AlaveteliLocalization.with_locale(AlaveteliLocalization.default_locale) do
      @public_body_category = PublicBodyCategory.new(public_body_category_params)
      if @public_body_category.save
        # FIXME: This can't handle failure (e.g. if a PublicBodyHeading
        # doesn't exist)
        if params[:headings]
          params[:headings].values.each do |heading_id|
            PublicBodyHeading.find(heading_id).add_category(@public_body_category)
          end
        end
        flash[:notice] = 'Category was successfully created.'
        redirect_to admin_categories_path
      else
        @public_body_category.build_all_translations
        render :action => 'new'
      end
    end
  end

  def edit
    @public_body_category.build_all_translations
    @tagged_public_bodies = PublicBody.find_by_tag(@public_body_category.category_tag)
  end

  def update
    @tagged_public_bodies = PublicBody.find_by_tag(@public_body_category.category_tag)

    heading_ids = []

    AlaveteliLocalization.with_locale(AlaveteliLocalization.default_locale) do
      if params[:public_body_category][:category_tag] && PublicBody.find_by_tag(@public_body_category.category_tag).count > 0 && @public_body_category.category_tag != params[:public_body_category][:category_tag]
        flash[:error] = "There are authorities associated with this category, so the tag can't be renamed"
        render :action => 'edit'
      else
        if params[:headings]
          heading_ids = params[:headings].values
          removed_headings = @public_body_category.public_body_heading_ids - heading_ids
          added_headings = heading_ids - @public_body_category.public_body_heading_ids

          unless removed_headings.empty?
            # remove the link objects
            deleted_links = PublicBodyCategoryLink.where(
              :public_body_category_id => @public_body_category.id,
              :public_body_heading_id => [removed_headings].flatten
            )
            deleted_links.delete_all

            #fix the category object
            @public_body_category.public_body_heading_ids = heading_ids
          end

          added_headings.each do |heading_id|
            # FIXME: This can't handle failure (e.g. if a
            # PublicBodyHeading doesn't exist)
            PublicBodyHeading.find(heading_id).add_category(@public_body_category)
          end
        end

        if @public_body_category.update(public_body_category_params)
          flash[:notice] = 'Category was successfully updated.'
          redirect_to edit_admin_category_path(@public_body_category)
        else
          @public_body_category.build_all_translations
          render :action => 'edit'
        end
      end
    end
  end

  def destroy
    @public_body_category.destroy
    flash[:notice] = "Category was successfully destroyed."
    redirect_to admin_categories_path
  end

  private

  def public_body_category_params
    translatable_params(
      params[:public_body_category],
      translated_keys: [:locale, :title, :description],
      general_keys: [:category_tag]
    )
  end

  def set_public_body_category
    @public_body_category = PublicBodyCategory.find(params[:id])
  end

end
