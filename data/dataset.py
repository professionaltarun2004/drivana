import os
from kaggle.api.kaggle_api_extended import KaggleApi

# Set your Kaggle credentials (replace these with your actual values)
os.environ['KAGGLE_USERNAME'] = 'tarunsandilya'
os.environ['KAGGLE_KEY'] = '74a14da224a8b19ca7e0cb1d9fb2494f'

# Initialize API
api = KaggleApi()
api.authenticate()

# Download the dataset
dataset = 'prondeau/the-car-connection-picture-dataset'
download_path = './'  # or any specific folder like 'data/'

print(f"📥 Downloading dataset: {dataset}")
api.dataset_download_files(dataset, path=download_path, unzip=True)
print("✅ Download complete.")
