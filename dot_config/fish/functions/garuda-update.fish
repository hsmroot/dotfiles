function garuda-update --description 'System Update + Chezmoi Cloud Sync'
    # 1. Run the real system binary, passing along any flags (e.g. --skip-mirrorlist)
    command garuda-update $argv
    set -l exit_code $status
    
    # 2. If the update succeeded (Exit Code 0):
    if test $exit_code -eq 0
        echo -e "\n🧙 System updated cleanly. Triggering Cloud Vault sync..."
        sync
    end
    
    return $exit_code
end
