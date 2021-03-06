require 'json'

class V1::GameController < ApplicationController

  def index
    render(json: Game.all, status: 200)
  end

  def create
    game = Game.new({player_id1:"1",player_id2:"2",board:[["","",""],["","",""],["","",""]],  moveNumber: 0})
    if game.save
      render(json: { game: game }, status: 200)
    else
        render(json: format_error(request.path, game.errors.full_messages), status: 401)
    end
  end

  def destroy
    game = Game.find_by(id: params[:id])
    if game.delete
        render(json: { game: game }, status: 200)
      else
          render(json: format_error(request.path, game.errors.full_messages), status: 401)
      end
    end


    def newmovement
        game =  Game.find_by(id: params[:gameId])
        currentPlayer = params[:playerId]
        x = params[:movement][1]
        y = params[:movement][2]
        board = JSON[game.board]
        esValido = game.movimientoValido?(board, x,y, game.result)
        if(esValido)
            board[x][y] = currentPlayer
            game.tablero = board
            game.moveNumber += 1
            game.resultado = game.getResultado(board, game.moveNumber)
            if game.save
                return render(json: {board: board, winner: game.result }, status: 200)
            end
            
        end
        render(json: {message: "Movimiento inválido vuelva a intentarlo" }, status: 200)
    end

end
