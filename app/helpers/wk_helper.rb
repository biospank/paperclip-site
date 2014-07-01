module WkHelper
  attr_accessor :header, :body, :footer

  DEFATULT_GENERATE_OPTS = {
    :header => true,
    :body => true,
    :footer => true,
    :preview => true
  }

  DEFATULT_MERGE_ALL_OPTS = {
    :preview => true
  }

  def generate(template, opts = {})
    # merge non distruttivo
    opts.merge!(DEFATULT_GENERATE_OPTS) { |key, oldval, newval| oldval }

    #FileUtils.rm './tmp/*.*'

    if opts[:header]
      logger.debug "rendering header..."
      self.header = File.new('./tmp/header.html', 'w')
      render_header(opts)
      header.close
    end

    if opts[:body]
      logger.debug "rendering body..."
      self.body = File.new('./tmp/body.html', 'w')
      render_body(opts)
      body.close
    end

    if opts[:footer]
      logger.debug "rendering footer..."
      self.footer = File.new('./tmp/footer.html', 'w')
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
    params << "--header-line" if opts[:header_line]
    params << "--footer-line" if opts[:footer_line]
    params << "#{body.path} ./tmp/#{template}.pdf"

    cmd_params = wk_cmd % params.join(' ')
    logger.info "executing: #{cmd_params}"
    system(cmd_params)

  end

  def render_header(opts={})

  end

  def render_body(opts={})

  end

  def render_footer(opts={})

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
