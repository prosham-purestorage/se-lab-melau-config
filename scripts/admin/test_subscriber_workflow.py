#!/usr/bin/env python3
"""
test_subscriber_workflow.py: Test the subscriber workflow from a simulated submodule environment.
"""
import sys
import subprocess
import tempfile
import shutil
from pathlib import Path
import os

def setup_test_subscriber_repo():
    """Create a temporary subscriber repo with config submodule structure"""
    temp_dir = Path(tempfile.mkdtemp())
    
    # Create subscriber repo structure
    subscriber_repo = temp_dir / "test-subscriber"
    subscriber_repo.mkdir()
    
    # Create config/shared submodule structure
    config_shared = subscriber_repo / "config" / "shared"
    config_shared.mkdir(parents=True)
    
    # Copy the entire source repo to simulate submodule
    source_repo = Path(__file__).resolve().parent.parent.parent
    shutil.copytree(source_repo, config_shared, dirs_exist_ok=True)
    
    return subscriber_repo, config_shared

def test_install_script(subscriber_repo, config_shared):
    """Test the install.py script in subscriber environment"""
    print("Testing install.py in subscriber environment...")
    
    os.chdir(subscriber_repo)
    install_script = config_shared / "scripts" / "subscriber" / "install.py"
    
    if not install_script.exists():
        print(f"ERROR: install.py not found at {install_script}")
        return False
    
    try:
        result = subprocess.run([sys.executable, str(install_script)], 
                              capture_output=True, text=True, check=True)
        print(f"✓ install.py completed successfully")
        
        # Check if .venv was created
        venv_dir = subscriber_repo / ".venv"
        if venv_dir.exists():
            print(f"✓ Virtual environment created at {venv_dir}")
        else:
            print(f"✗ Virtual environment not found at {venv_dir}")
            return False
            
        return True
    except subprocess.CalledProcessError as e:
        print(f"✗ install.py failed: {e}")
        print(f"STDOUT: {e.stdout}")
        print(f"STDERR: {e.stderr}")
        return False

def test_update_script(subscriber_repo, config_shared):
    """Test the update.py script in subscriber environment"""
    print("Testing update.py in subscriber environment...")
    
    os.chdir(subscriber_repo)
    update_script = config_shared / "scripts" / "subscriber" / "update.py"
    
    if not update_script.exists():
        print(f"ERROR: update.py not found at {update_script}")
        return False
    
    # Create export directory
    export_dir = subscriber_repo / "export"
    export_dir.mkdir(exist_ok=True)
    
    # Test all three export types
    test_cases = [
        ("env", "export/lab-config.env"),
        ("json", "export/lab-config.json"),
        ("ps1", "export/lab-config.ps1")
    ]
    
    success = True
    for export_type, output_path in test_cases:
        print(f"  Testing {export_type} export...")
        
        try:
            cmd = [
                sys.executable, str(update_script),
                "--type", export_type,
                "--output", output_path,
                "--config", str(config_shared / "lab-config.yml"),
                "--secrets", str(config_shared / "secrets.yml.encrypted"),
                "--key", str(Path.home() / ".purestorage/se-lab-melau.key")
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True, check=True)
            
            # Check if output file was created
            output_file = subscriber_repo / output_path
            if output_file.exists():
                print(f"    ✓ {export_type} export created: {output_file}")
                
                # Check file permissions (should be 400)
                file_mode = oct(output_file.stat().st_mode)[-3:]
                if file_mode == "400":
                    print(f"    ✓ {export_type} file has correct permissions (400)")
                else:
                    print(f"    ✗ {export_type} file has incorrect permissions ({file_mode})")
                    success = False
            else:
                print(f"    ✗ {export_type} export file not created")
                success = False
                
        except subprocess.CalledProcessError as e:
            print(f"    ✗ {export_type} export failed: {e}")
            print(f"    STDOUT: {e.stdout}")
            print(f"    STDERR: {e.stderr}")
            success = False
    
    return success

def test_makefile_integration(subscriber_repo, config_shared):
    """Test using a Makefile from subscriber repo"""
    print("Testing Makefile integration in subscriber environment...")
    
    # Copy the actual Makefile template instead of creating a test one
    template_makefile = config_shared / "templates" / "Makefile.subscriber"
    subscriber_makefile = subscriber_repo / "Makefile"
    
    if template_makefile.exists():
        import shutil
        shutil.copy2(template_makefile, subscriber_makefile)
        print("✓ Copied Makefile template to subscriber repo")
    else:
        # Fallback to creating test Makefile if template doesn't exist
        makefile_content = """# Test Makefile for subscriber repo
.PHONY: config

config:
\tmkdir -p export
\tpython3 config/shared/scripts/subscriber/install.py
\tpython3 config/shared/scripts/subscriber/update.py --type env --output export/lab-config.env --config config/shared/lab-config.yml --secrets config/shared/secrets.yml.encrypted
\tpython3 config/shared/scripts/subscriber/update.py --type json --output export/lab-config.json --config config/shared/lab-config.yml --secrets config/shared/secrets.yml.encrypted
\tpython3 config/shared/scripts/subscriber/update.py --type ps1 --output export/lab-config.ps1 --config config/shared/lab-config.yml --secrets config/shared/secrets.yml.encrypted
"""
        with open(subscriber_makefile, 'w') as f:
            f.write(makefile_content)
        print("✓ Created fallback test Makefile")
    
    os.chdir(subscriber_repo)
    
    try:
        result = subprocess.run(["make", "config"], capture_output=True, text=True, check=True)
        print("✓ Makefile integration test passed")
        
        # Verify all export files were created with correct permissions
        export_files = ["export/lab-config.env", "export/lab-config.json", "export/lab-config.ps1"]
        for export_file in export_files:
            file_path = subscriber_repo / export_file
            if file_path.exists():
                file_mode = oct(file_path.stat().st_mode)[-3:]
                if file_mode == "400":
                    print(f"  ✓ {export_file} created with correct permissions")
                else:
                    print(f"  ✗ {export_file} has incorrect permissions ({file_mode})")
                    return False
            else:
                print(f"  ✗ {export_file} was not created")
                return False
        
        return True
    except subprocess.CalledProcessError as e:
        print(f"✗ Makefile integration test failed: {e}")
        print(f"STDOUT: {e.stdout}")
        print(f"STDERR: {e.stderr}")
        return False

def main():
    """Run all subscriber workflow tests"""
    print("🧪 Testing Subscriber Workflows")
    print("=" * 50)
    
    # Setup test environment
    print("Setting up test subscriber repository...")
    subscriber_repo, config_shared = setup_test_subscriber_repo()
    print(f"Test repo created at: {subscriber_repo}")
    
    try:
        # Run tests
        tests = [
            ("Install Script", lambda: test_install_script(subscriber_repo, config_shared)),
            ("Update Script", lambda: test_update_script(subscriber_repo, config_shared)),
            ("Makefile Integration", lambda: test_makefile_integration(subscriber_repo, config_shared))
        ]
        
        results = []
        for test_name, test_func in tests:
            print(f"\n--- {test_name} ---")
            success = test_func()
            results.append((test_name, success))
        
        # Summary
        print(f"\n{'='*50}")
        print("Test Results Summary:")
        all_passed = True
        for test_name, success in results:
            status = "✓ PASS" if success else "✗ FAIL"
            print(f"  {test_name}: {status}")
            if not success:
                all_passed = False
        
        if all_passed:
            print("\n🎉 All subscriber workflow tests passed!")
            return 0
        else:
            print("\n❌ Some subscriber workflow tests failed!")
            return 1
            
    finally:
        # Cleanup
        print(f"\nCleaning up test directory: {subscriber_repo.parent}")
        shutil.rmtree(subscriber_repo.parent)

if __name__ == "__main__":
    sys.exit(main())
