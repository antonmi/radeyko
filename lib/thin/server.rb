#monkeypatch for Ctrl+C

class Thin::Server
  def stop!
    if @backend.started_reactor?
      log_info "Stopping ..."
    else
      log_info "Stopping Thin ..."
    end

    @backend.stop!
    EM.stop
  end
end