class BoardsController < ApplicationController
  
  before_action :set_target_board, only: %i[show edit update destroy]
  
  # 一覧画面
  def index
    @boards = params[:tag_id].present? ? Tag.find(params[:tag_id]).boards : Board.all
    @boards = @boards.page(params[:page])
  end
  
  # 新規作成画面
  def new
    @board = Board.new(flash[:board])
    
  end
  
  # 新規作成画面
  def create
    
    board = Board.new(board_params)
    
    if board.save
      flash[:notice] = "「#{board.title}」の掲示板を作成しました"
      redirect_to board
    else
      redirect_to new_board_path, flash: {
        board: board,
        error_messages: board.errors.full_messages
      }
    end
  end
  
  # 新規作成画面
  def show
    @comment = Comment.new(board_id: @board.id)
  end
  
  # 新規作成画面
  def edit
     @board.attributes = flash[:board] if flash[:board]
  end
  
  # 新規作成画面
  def update
    if @board.update(board_params)
      redirect_to @board
    else
      redirect_to :back, flash: {
        board: @board,
        error_messages: @board.errors.full_messages
      }
    end
  end
  
  # 新規作成画面
  def destroy
    @board.destroy
    redirect_to boards_path, flash: { notice: "「#{@board.title}」の掲示板が削除されました。"}
  end
  
  private
  # ストロングパラメーターズ
  def board_params
    params.require(:board).permit(:name, :title, :body, tag_ids: [])
  end
  
  # 新規作成画面
  def set_target_board
    @board = Board.find(params[:id])
  end
end
