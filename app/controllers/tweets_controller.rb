class TweetsController < ApplicationController
     before_action :set_tweet, only: [:edit, :show]
     # ↑コントローラで定義されたアクションが実行される前に、共通の処理を行う
     before_action :move_to_index, except: [:index, :show, :search]
     # ↑exceptオプション:ログインしていなくても、詳細ページに遷移できる仕様
     def index
        @tweets = Tweet.includes(:user).order("created_at DESC")
     #    ↑N＋1問題の解消と投稿の並び順のメソッド
     end
     
     def new
        @tweet = Tweet.new
     end
     # ↑新規投稿のインスタンス
     def create
        Tweet.create(tweet_params)
     end
     # ↑保存のインスタンス
     def destroy
        tweet = Tweet.find(params[:id])
        tweet.destroy
     end
     # ↑削除のインスタンス
     def edit
     end
     # ↑編集のインスタンス
     def update
        tweet = Tweet.find(params[:id])
        tweet.update(tweet_params)
     end
     # ↑更新のインスタンス
     def show
         @comment = Comment.new
         @comments = @tweet.comments.includes(:user)
     end
     # ↑詳細のインスタンス
     
     def search
        @tweets = Tweet.search(params[:keyword])
     end
# 　　　↑検索機能の追加
     
     private
     
     def tweet_params
        params.require(:tweet).permit(:image, :text).merge(user_id: current_user.id)
     end
     # ↑表示内容・項目（カラム）
     def set_tweet
        @tweet = Tweet.find(params[:id])
     end
     # ↑共通の処理
     def move_to_index
         unless user_signed_in?
             redirect_to action: :index
         end
     end
end