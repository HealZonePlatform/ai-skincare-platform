import os

# Define the file structure
file_structure = {
    "lib": {
        "api": ["auth_api_service.dart"],
        "providers": ["auth_provider.dart"],
        "screens": {
            "auth": ["login_screen.dart", "register_screen.dart"],
            "_files": ["home_screen.dart"]
        },
        "services": ["secure_storage_service.dart"],
        "utils": ["api_constants.dart"],
        "_files": ["main.dart"]
    }
}

# Helper function to create structure
def create_structure(base_path, structure):
    for key, value in structure.items():
        if key == "_files":
            for file in value:
                file_path = os.path.join(base_path, file)
                with open(file_path, "w") as f:
                    f.write(f"// {file}\n")
        else:
            dir_path = os.path.join(base_path, key)
            os.makedirs(dir_path, exist_ok=True)
            if isinstance(value, dict):
                create_structure(dir_path, value)
            else:
                for file in value:
                    file_path = os.path.join(dir_path, file)
                    with open(file_path, "w") as f:
                        f.write(f"// {file}\n")

# Create the structure starting from current working directory
base_directory = "frontend/mobile-app/"
os.makedirs(base_directory, exist_ok=True)
create_structure(base_directory, file_structure)
