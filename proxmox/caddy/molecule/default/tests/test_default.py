import testinfra

def test_caddy_file(host):
    f = host.file('/etc/caddy/Caddyfile')
    assert f.exists

def test_service_running(host):
    s = host.service('caddy')
    assert s.is_running
    assert s.is_enabled
    
def test_web_url_accessible(host):
    output = host.run("curl http://localhost")
    assert output.rc == 0
    assert output.succeeded

def test_port_80_listening(host):
    socket = host.socket("tcp://0.0.0.0:80")
    assert socket.is_listening