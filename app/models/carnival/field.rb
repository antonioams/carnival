module Carnival
  class Field
    attr_accessor :size, :column, :line, :name, :params

    def initialize(name, params={})
      @params = params
      @name = name
      set_position_by_params
      validate
    end

    def hidden?(record, controller)
      if @params.has_key?(:hide_if)
        block = @params[:hide_if]
        controller.instance_variable_set(:@record, record)
        controller.instance_eval(&block)
      else
        false
      end
    end

    def specified_association?
      not get_association_and_field[:association].nil?
    end

    def association_name
      get_association_and_field[:association] || @name
    end

    def association_field_name
      if specified_association?
        get_association_and_field[:field]
      end
    end

    def name_for_translation
      @name.to_s.gsub('.', '_')
    end

    def css_class
      if @params[:css_class]
        return @params[:css_class]
      else
        return ""
      end
    end

    def date_filter?
      @params[:date_filter]
    end

    def default_date_filter
      if @params[:date_filter_default]
        @params[:date_filter_default]
      else
        date_filter_periods.first.first
      end
    end

    def date_filter_periods
      if @params[:date_filter_periods]
        @params[:date_filter_periods]
      else
        {:today => ["#{I18n.l Date.today, format: :default}", "#{I18n.l Date.today, format: :default}"],
         :yesterday => ["#{I18n.l Date.today - 1.day, format: :default}", "#{I18n.l Date.today - 1.day, format: :default}"],
         :this_week => ["#{I18n.l Date.today.beginning_of_week, format: :default}", "#{I18n.l Date.today.end_of_week, format: :default}"],
         :last_week => ["#{I18n.l (Date.today - 1.week).beginning_of_week, format: :default}", "#{I18n.l (Date.today - 1.week).end_of_week, format: :default}"],
         :this_month => ["#{I18n.l Date.today.beginning_of_month, format: :default}", "#{I18n.l Date.today.end_of_month, format: :default}"],
         :last_month => ["#{I18n.l (Date.today - 1.month).beginning_of_month, format: :default}", "#{I18n.l (Date.today - 1.month).end_of_month, format: :default}"],
         :this_year => ["#{I18n.l Date.today.beginning_of_year, format: :default}", "#{I18n.l Date.today.end_of_year, format: :default}"],
         :last_year => ["#{I18n.l (Date.today - 1.year).beginning_of_year, format: :default}", "#{I18n.l (Date.today - 1.year).end_of_year, format: :default}"]
        }
      end
    end

    def default_sortable?
      @params[:sortable] && @params[:sortable].class == Hash && @params[:sortable][:default] == true
    end

    def default_sort_direction
      if default_sortable?
        if @params[:sortable][:direction]
          return @params[:sortable][:direction]
        end
      end
      return :asc
    end

    def depends_on
      @params[:depends_on]
    end

    def nested_form?
      @params[:nested_form]
    end

    def nested_form_allow_destroy?
      @params[:nested_form_allow_destroy]
    end

    def nested_form_modes? (mode)
      associate = get_associate_nested_form_mode
      return true if associate.present? && mode == :associate
      return @params[:nested_form_modes].include?(mode) unless @params[:nested_form_modes].nil?
      return false
    end

    def nested_form_scope
      return nil if !nested_form_modes? :associate
      associate_mode =  get_associate_nested_form_mode
      return nil if associate_mode.is_a? Symbol
      return associate_mode[:scope] if associate_mode[:scope].present?
    end

    def sortable?
      return true if @params[:sortable].nil?
      return true if @params[:sortable]
      return true if @params[:sortable].class == Hash
      return false
    end

    def sortable_params
      return false if !sortable?
      return @params[:sortable].to_json if @params[:sortable].class == Hash
      return true
    end

    def searchable?
      @params[:searchable]
    end

    def advanced_searchable?
      @params[:advanced_search]
    end

    def show_as_list
      @params[:show_as_list]
    end

    def advanced_search_operator
      return @params[:advanced_search][:operator] if advanced_searchable? and @params[:advanced_search][:operator].present?
      :like
    end

    def actions
      @params[:actions]
    end

    def valid_for_action?(action)
      return false if @params[:actions].nil?
      @params[:actions].include?(action)
    end

    def as
      @params[:as]
    end

    def widget
      @params[:widget].present? ? @params[:widget] : :input
    end

    def show_view
      @params[:show_view]
    end

    def sort_name
      @name.to_s
    end

    def presenter_class
      @params[:presenter]
    end

    def partial_name
      @params[:partial_name] || name.to_s
    end

    def add_empty_option
      @params[:add_empty_option].present? && @params[:add_empty_option]
    end

    private

    def get_association_and_field
      split = @name.to_s.split('.')
      if split.size > 1
        association = split[0]
        field = split[1]
      else
        field = split[0]
      end
      { association: association, field: field }
    end

    def validate
      if nested_form_modes?(:new) and nested_form_modes?(:associate)
        raise ArgumentError.new("field does not support nested_forms_modes with :new and :associate options at same time")
      end
    end

    def set_position_by_params
      if @params[:position].present?
        @line = @params[:position][:line]
        @column =  @params[:position][:column]
        @size = @params[:position][:size]
      end
    end

    def get_associate_nested_form_mode
      return nil if @params[:nested_form_modes].nil?
      @params[:nested_form_modes].each do |mode|
        if mode.is_a? Hash
          return mode[:associate] if mode[:associate].present?
        elsif mode.is_a? Symbol
          return mode if mode == :associate
        end
      end
      nil
    end
  end
end
