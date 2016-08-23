module Up

  if File.exists? '~/.config/up/config'
    Cfg  			= Asetus.cfg name: 'up'
  else
    CFG = Asetus.new :name=>'up', :load=>false
    CFG.default.debug 		= true
    CFG.default.uploads_dir	= '/home/user/public/uploads'
    CFG.default.web.localhost 	= '127.0.0.1'
    CFG.default.web.localport	= 8888
    CFG.load
    if CFG.create
      CFG.save
      puts '+ base configuration built at: ~/.config/up/config'
      exit 0
    else
      Cfg = CFG.cfg
      Process.daemon if not Cfg.debug
    end
  end

  class Web < Sinatra::Base
    set :server, 'thin'
    set :bind, Cfg.web.localhost
    set :port, Cfg.web.localport
    set :server_settings, {:AccessLog => []}
    set :public_dir, File.dirname(__FILE__) + '/public'
    set :sessions, false

    def fn_gen filext
      tfn = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join
      if not Dir.entries(Cfg.uploads_dir).include?([tfn, filext].join('.'))
        return [tfn, filext].join('.')
      else
        fn_gen
      end
    end

    get '/' do
      haml :index
    end

    post '*' do
      if not params['myfile'][:filename] =~ /./
        fna = [ params['myfile'][:filename], '.raw' ].join('.')
      else
        fna = params['myfile'][:filename].split('.')[-1]
      end
      filename = fn_gen fna.split('.')[-1]
      File.open([Cfg.uploads_dir, '/'].join + filename, 'w') do |f|
        f.write(params['myfile'][:tempfile].read)
      end 
      redirect File.join('/uploads', filename)
    end

    get '/uploads/:filename' do
      begin
        puts [ Time.now.to_s, File.join('/uploads', params[:filename]) ].join(' ') if Cfg.debug
        if Dir.entries([Cfg.uploads_dir, '/'].join).include?(params[:filename])
          send_file [ [Cfg.uploads_dir, '/'].join, params[:filename] ].join
        else
          @filename = params[:filename]
          haml :error
        end
      end
    end

  end
end

