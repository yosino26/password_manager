
#!/bin/bash

PASSWORD_FILE="passwords.txt"
ENCRYPTED_FILE="passwords.txt.gpg"

echo "パスワードマネージャーへようこそ！"

while true; do
    echo "次の選択肢から入力してください(Add Password/Get Password/Exit)："
    read -r choice

    case $choice in
        "Add Password")
            read -p "サービス名を入力してください: " service
            read -p "ユーザー名を入力してください: " username
            read -s -p "パスワードを入力してください: " password
            echo ""

            # 暗号化されたファイルがあれば復号化して追記
            if [ -f "$ENCRYPTED_FILE" ]; then
                gpg --quiet --batch --yes --decrypt --output "$PASSWORD_FILE" "$ENCRYPTED_FILE"
            fi

            echo "$service:$username:$password" >> "$PASSWORD_FILE"

            # ファイルを暗号化
            gpg --quiet --batch --yes --symmetric --cipher-algo AES256 --output "$ENCRYPTED_FILE" "$PASSWORD_FILE"

            # 平文のファイルを削除
            rm -f "$PASSWORD_FILE"

            echo "パスワードの追加は成功しました。"
            ;;
        
        "Get Password")
            if [ ! -f "$ENCRYPTED_FILE" ]; then
                echo "パスワードデータが存在しません。"
                continue
            fi

            read -p "サービス名を入力してください: " search_service

            # 一時的に復号化
            gpg --quiet --batch --yes --decrypt --output "$PASSWORD_FILE" "$ENCRYPTED_FILE"

            # サービス名を検索
            result=$(grep "^$search_service:" "$PASSWORD_FILE")

            if [ -z "$result" ]; then
                echo "そのサービスは登録されていません。"
            else
                echo "検索結果:"
                echo "$result" | awk -F: '{print "サービス名: "$1"\nユーザー名: "$2"\nパスワード: "$3}'
            fi

            # 復号化したファイルを削除
            rm -f "$PASSWORD_FILE"
            ;;
        
        "Exit")
            echo "Thank you!"
            exit 0
            ;;
        
        *)
            echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
            ;;
    esac
done
