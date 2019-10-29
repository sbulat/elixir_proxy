defmodule KeenProxy.Cache do
  use Nebulex.Cache,
    otp_app: :keen_proxy,
    adapter: Nebulex.Adapters.Local
end
