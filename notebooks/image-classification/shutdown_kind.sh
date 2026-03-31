#!/bin/bash

echo "--------------------------------"
echo "Shutting down kind cluster..."
kind delete cluster
echo "Kind cluster deleted."
echo "--------------------------------"