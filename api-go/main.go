package main

import (
    "log"
    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
    "gorm.io/driver/mysql"
)

type User struct {
    ID       uint   `gorm:"primaryKey"`
    Name     string `gorm:"size:100"`
    Email    string `gorm:"uniqueIndex;size:100"`
    Password string `gorm:"size:255"`
}

func main() {
    router := gin.Default()

    // MySQL縺ｸ縺ｮ謗･邯壽ュ蝣ｱ
    dsn := "zeninvestor:zenpass@tcp(localhost:3306)/zeninv?charset=utf8mb4&parseTime=True&loc=Local"
    db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
    if err != nil {
        log.Fatal("failed to connect to database:", err)
    }

    router.GET("/migration", func(c *gin.Context) {
        // User繝・・繝悶Ν縺ｮ蟄伜惠繝√ぉ繝・け
        if db.Migrator().HasTable(&User{}) {
            c.JSON(200, gin.H{"message": "User table already exists. Migration skipped."})
            return
        }

        // 繝・・繝悶Ν縺ｮ閾ｪ蜍輔・繧､繧ｰ繝ｬ繝ｼ繧ｷ繝ｧ繝ｳ
        err := db.AutoMigrate(&User{})
        if err != nil {
            c.JSON(500, gin.H{"error": "failed to migrate database"})
            return
        }

        // 繝ｦ繝ｼ繧ｶ繝ｼ繝・・繧ｿ繧剃ｽ懈・
        users := []User{
            {Name: "Alice", Email: "alice@example.com", Password: "password1"},
            {Name: "Bob", Email: "bob@example.com", Password: "password2"},
            {Name: "Charlie", Email: "charlie@example.com", Password: "password3"},
        }

        // 繝ｦ繝ｼ繧ｶ繝ｼ繝・・繧ｿ繧偵ョ繝ｼ繧ｿ繝吶・繧ｹ縺ｫ霑ｽ蜉
        for _, user := range users {
            result := db.Create(&user)
            if result.Error != nil {
                c.JSON(500, gin.H{"error": "Failed to insert user: " + result.Error.Error()})
                return
            }
        }

        log.Println("Database connected and User table migrated successfully. Users added.")
        c.JSON(200, gin.H{"message": "Migration completed successfully"})
    })

    router.Run(":8086")
}

