defmodule QuickExWeb.ApiController do
  use Phoenix.Controller
  import Ecto.Query
  require Logger
  alias QuickEx.{Repo, Quick, Utils}

  def delete(req, params) do
    if not Map.has_key?(params, "id") do
      json(req, %{"error" => "missing param `id`"})
    end

    if not Map.has_key?(params, "token") do
      json(req, %{"error" => "missing param `token`"})
    end

    id = Map.get(params, "id")
    token = Map.get(params, "token")
    quick = Repo.one(from(q in Quick, where: q.qid == ^id, select: q))

    if quick == nil do
      Plug.Conn.put_status(req, 404)
      json(req, %{"error" => "can't find Quick with id #{id}"})
    end

    if token == quick.delete_token do
      case Repo.delete(quick) do
        {:ok, _} ->
          Plug.Conn.put_status(req, 204)
          json(req, %{"status" => "ok"})

        {:err, _} ->
          json(req, %{"error" => "error deleting"})
      end
    else
      Plug.Conn.put_status(req, 401)
      json(req, %{"error" => "invalid token!"})
    end
  end

  def get(req, params) do
    id = Map.get(params, "id")
    quick = Repo.one(from(q in Quick, where: q.qid == ^id, select: q))

    if quick == nil do
      Plug.Conn.put_status(req, 404)
      json(req, %{"error" => "can't find Quick with id #{id}"})
    end

    changeset = Ecto.Changeset.change(quick)
    item_changeset = Ecto.Changeset.change(changeset, views: quick.views + 1)
    Repo.update!(item_changeset)

    json(req, %{
      "data" => quick.data,
      "views" => quick.views
    })
  end

  def create(req, params) do
    content = List.first(Map.keys(params))
    Logger.info("body = #{content}")

    if content == nil do
      json(req, %{"error" => "body is invalid"})
    end

    query_attrs = %{
      data: content,
      delete_token: Utils.randon_token(),
      views: 0,
      qid: Utils.random_id()
    }

    doc =
      Quick.changeset(%Quick{}, query_attrs)
      |> Repo.insert()


    case doc do
      {:ok, data} ->
        id = data.qid
        json(req, %{"quick_id" => id})

      {:err, err} ->
        json(req, %{"error" => err})
    end
  end
end

