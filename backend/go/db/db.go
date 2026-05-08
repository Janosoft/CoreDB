package db

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"os"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

var DB *sql.DB

type Config struct {
	Env string `json:"env"`
	Db  map[string]struct {
		Host     string `json:"host"`
		User     string `json:"user"`
		Password string `json:"password"`
		Database string `json:"database"`
	} `json:"db"`
}

func Init() error {
	configPath := "../../db/mysql/config.json"

	file, err := os.Open(configPath)
	if err != nil {
		return err
	}
	defer file.Close()

	byteValue, err := io.ReadAll(file)
	if err != nil {
		return err
	}

	var config Config

	err = json.Unmarshal(byteValue, &config)
	if err != nil {
		return err
	}

	env := "development"

	dbConfig := config.Db[env]

	dsn := fmt.Sprintf(
		"%s:%s@tcp(%s)/%s?parseTime=true",
		dbConfig.User,
		dbConfig.Password,
		dbConfig.Host,
		dbConfig.Database,
	)

	DB, err = sql.Open("mysql", dsn)
	if err != nil {
		return err
	}

	DB.SetMaxOpenConns(10)
	DB.SetMaxIdleConns(5)
	DB.SetConnMaxLifetime(5 * time.Minute)

	return DB.Ping()
}
