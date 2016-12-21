module Up

  if File.exists? '~/.config/up/config'
    Cfg  			= Asetus.cfg name: 'up'
  else
    CFG = Asetus.new :name=>'up', :load=>false
    CFG.default.debug 		= true
    CFG.default.app.upload_dir  = '/home/user/public/uploads'
    CFG.default.app.times       = [ 1, 5, 10, 30, '1h', '1d' ]
    CFG.default.app.log		= '/home/user/.config/up/log'
    CFG.default.web.localhost 	= '127.0.0.1'
    CFG.default.web.localport	= 8888
    CFG.load
    if CFG.create
      CFG.save
      puts '+ base configuration built at: ~/.config/up/config'
      exit 0
    else
      Cfg = CFG.cfg
      if Cfg.debug
        target = STDOUT
        Log = Logger.new target
      else
        Log = Logger.new Cfg.app.log
        Process.daemon
      end
    end
  end

  class Web < Sinatra::Base
    set :server, 'thin'
    set :bind, Cfg.web.localhost
    set :port, Cfg.web.localport
    set :server_settings, {:AccessLog => []}
    set :public_dir, File.dirname(__FILE__) + '/public'
    set :sessions, false


    def get_help err, arg=nil
      case err.to_i
      when 0 # no file specified #
        error = 'no file specified.'
      when 1 # file not found #
        error = [ 'file not found - ', arg ].join
      else
        error = 'unable to process user request.'
      end
      return error
    end

    def init_env
      Cfg.app.times.each do |t|
        if not File.exist?(File.join(Cfg.app.upload_dir, t.to_s))
          Log.debug [ 'adding missing directory:', File.join(Cfg.app.upload_dir, t.to_s) ].join(' ')
          system([ 'mkdir', File.join(Cfg.app.upload_dir, t.to_s) ].join(' '))
        end
      end
    end 

    def fn_gen filext
      tfn = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join
      if not Dir.entries(Cfg.app.upload_dir).include?([tfn, filext].join('.'))
        return [tfn, filext].join('.')
      else
        fn_gen
      end
    end

    def time_verify tm
      if Cfg.app.times.include?(tm.to_i) or tm.to_i == 0
        return true
      else
        return false
      end
    end

    get '/help/:error' do
      @filename = get_help params[:error]
      Log.error [ 'ERROR: ', @filename ].join
      haml :error
    end

    get '/' do
      init_env
      @times = Cfg.app.times
      haml :index
    end

    post '*' do
      if not params['myfile']
        redirect '/help/0'
      end
      if not params['myfile'][:filename] =~ /./
        fna = [ params['myfile'][:filename], '.txt' ].join('.')
      else
        fna = params['myfile'][:filename].split('.')[-1]
      end
      filename = fn_gen fna.split('.')[-1]
      if time_verify(params['time'])
        @time = params['time']
      else
        @time = 0
      end
      File.open([Cfg.app.upload_dir, '/', @time, '/'].join + filename, 'w') do |f|
        f.write(params['myfile'][:tempfile].read)
      end 
      redirect File.join('/uploads', @time.to_s, filename)
    end

    get '/uploads/' do
      redirect '/'
    end

    get '/uploads/:filename' do
      redirect '/'
    end

    get '/uploads/:time/:filename' do
      begin
        Log.debug [ Time.now.to_s, File.join('/uploads', params[:time], params[:filename]) ].join(' ') if Cfg.debug
        if Dir.entries([Cfg.app.upload_dir, '/', params[:time], '/'].join).include?(params[:filename])
          send_file [ [Cfg.app.upload_dir, '/', params[:time], '/'].join, params[:filename] ].join
        else
          @filename = get_help(1, params[:filename])
          haml :error
        end
      end
    end

  end
end

