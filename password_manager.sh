
#!/bin/bash

echo "パスワードマネージャーへようこそ！"

while true; do
    echo "次の選択肢から入力してください(Add Password/Get Password/Exit)："
    read choice

    case $choice in
        "Add Password")
            # サービス名、ユーザー名、パスワードを入力
            read -p "サービス名を入力してください：" service
            read -p "ユーザー名を入力してください：" username
            read -s -p "パスワードを入力してください：" password
            echo ""
            # 入力情報をファイルに保存
            echo "$service:$username:$password" >> passwords.txt
            echo "パスワードの追加は成功しました。"
            ;;

        "Get Password")
            # サービス名を入力

            # サービス名が保存されているか確認

            # サービスが保存されていれば出力
            ;;
        "Exit")
            # プログラム終了
            echo "Thank you!"
            break
            ;;
        *)
            # 入力が無効な場合
            echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
            ;;
    esac
done

