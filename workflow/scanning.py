import nmap3
import asyncio
from typing import Dict, Any

async def run_scanning(domain: str, scan_results: Dict[str, Any], log_callback) -> None:
    """
    Step 2: Scanning
    Uses Nmap to find open ports.
    """
    log_callback("Starting Nmap Scan...")
    
    try:
        nm = nmap3.NmapScanTechniques()
        # Quick scan of top ports to keep it fast for the demo
        # -F: Fast mode - Scan fewer ports than the default scan
        # -T4: Aggressive timing template
        result = nm.nmap_top_ports(domain, args="-F -T4")
        
        open_ports = []
        if isinstance(result, dict) and domain in result:
            for port_info in result.get(domain, {}).get('ports', []):
                if port_info.get('state') == 'open':
                    port = port_info.get('portid')
                    proto = port_info.get('protocol', 'tcp')
                    open_ports.append(int(port))
                    log_callback(f"Found open port: {port}/{proto}")
        else:
            log_callback("Nmap could not resolve the host or found no ports.")
            
        scan_results["results"]["open_ports"] = open_ports
        
    except Exception as e:
        log_callback(f"Scanning error: {str(e)}")
        
    await asyncio.sleep(2)
