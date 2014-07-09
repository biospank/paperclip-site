module WkHelper
  attr_accessor :header, :body, :footer

  DEFATULT_GENERATE_OPTS = {
    :header => true,
    :body => true,
    :footer => true,
    :preview => true
  }

  PUBLIC_PATH = "#{Rails.root}/public"
  PDF_PATH = "pdfs"

  def generate(template, opts = {})
    # merge non distruttivo
    opts.merge!(DEFATULT_GENERATE_OPTS) { |key, oldval, newval| oldval }

    #FileUtils.rm './tmp/*.*'

    xyz = Random.rand(100)

    if opts[:header]
      logger.debug "rendering header..."
      self.header = File.new("./tmp/tpls/header#{xyz}.html", 'w')
      render_header(opts)
      header.close
    end

    if opts[:body]
      logger.debug "rendering body..."
      self.body = File.new("./tmp/tpls/body#{xyz}.html", 'w')
      render_body(opts)
      body.close
    end

    if opts[:footer]
      logger.debug "rendering footer..."
      self.footer = File.new("./tmp/tpls/footer#{xyz}.html", 'w')
      render_footer(opts)
      footer.close
    end

    params = []
    params << "-O #{opts[:layout]}" if opts[:layout]
    params << "--header-html #{header.path}" if opts[:header]
    params << "--footer-html #{footer.path}" if opts[:footer]
    params << "--margin-top #{opts[:margin_top]}" if opts[:margin_top]
    params << "--margin-bottom #{opts[:margin_bottom]}" if opts[:margin_bottom]
    params << "--header-spacing #{opts[:header_spacing]}" if opts[:header_spacing]
    params << "--footer-spacing #{opts[:footer_spacing]}" if opts[:footer_spacing]
    params << "--debug-javascript"
    params << "--header-line" if opts[:header_line]
    params << "--footer-line" if opts[:footer_line]
    params << "#{body.path} #{WkHelper.root_path.join('public', PDF_PATH, template)}.pdf"

    cmd_params = wk_cmd % params.join(' ')
    logger.info "executing: #{cmd_params}"
    system(cmd_params)

    "#{File.join(PUBLIC_PATH, PDF_PATH, template)}.pdf"

  end

  def render_header(opts={})

  end

  def render_body(opts={})

  end

  def render_footer(opts={})

  end

  def self.root_path
    String === Rails.root ? Pathname.new(Rails.root) : Rails.root
  end

  def self.add_extension(filename, extension)
    (File.extname(filename.to_s)[1..-1] == extension) ? filename : "#{filename}.#{extension}"
  end

  def wk_stylesheet_link_tag(*sources)
    css_dir = WkHelper.root_path.join('public', 'wk', 'stylesheets')
    css_text = sources.collect { |source|
      source = WkHelper.add_extension(source, 'css')
      "<style type='text/css'>#{File.read(css_dir.join(source))}</style>"
    }.join("\n")
    css_text.respond_to?(:html_safe) ? css_text.html_safe : css_text
  end

  def wk_image_tag(img, options={})
    image_tag "file:///#{WkHelper.root_path.join('public', 'wk', 'images', img)}", options
  end

  def wk_javascript_src_tag(jsfile, options={})
    jsfile = WkHelper.add_extension(jsfile, 'js')
    src = "file:///#{WkHelper.root_path.join('public', 'wk', 'javascripts', jsfile)}"
    content_tag("script", "", { "type" => Mime::JS, "src" => path_to_javascript(src) }.merge(options))
  end

  def wk_javascript_include_tag(*sources)
    js_text = sources.collect{ |source| wk_javascript_src_tag(source, {}) }.join("\n")
    js_text.respond_to?(:html_safe) ? js_text.html_safe : js_text
  end

  private

  def wk_cmd
    if Rails.env.production?
      #"#{Rails.root}/bin/wkhtmltopdf.exe %s"
      "wkhtmltopdf %s"
    else
      "wkhtmltopdf %s"
    end
  end

end
