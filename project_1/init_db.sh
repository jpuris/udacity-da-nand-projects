#!/bin/sh

docker run -p 127.0.0.1:5432:5432 -v $(pwd)/hr-dataset.csv:/tmp/hr-dataset.csv --name udacity_da_nand_project_1 -e POSTGRES_PASSWORD=postgres postgres