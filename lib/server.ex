require Logger

defmodule ExTimeWinService.Server do
  def start(port) do
    Logger.info('ExTimeWinService.Server starting')

    tcp_options = [:binary, {:packet, 0}, {:active, false}]
    {:ok, socket} = :gen_tcp.listen(port, tcp_options)
    listen(socket)
  end

  defp listen(socket) do
    Logger.info('ExTimeWinService.Server listening')

    {:ok, conn} = :gen_tcp.accept(socket)
    spawn(fn -> recv(conn) end)
    listen(socket)
  end

  defp recv(conn) do
    case :gen_tcp.recv(conn, 0) do
      {:ok, data} ->
        Logger.info('ExTimeWinService.Server connection received data')
        :gen_tcp.send(conn, data)
        recv(conn)
      {:error, :closed} ->
        Logger.info('ExTimeWinService.Server connection closed')
        :ok
    end
  end
end
