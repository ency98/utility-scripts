# Bash utility scripts
Various bash scripts to do various things. Most are wrappers to do routine tasks where I keep forgetting basic command syntax, or to filter and prettify output of common tasks. 

Scripts are mostly slapped together with little thought, overly engineered, ham fisted, and often opnionated.   

## random-64-char-hex.sh
- Generate 24 random 64 character hex strings.
<img width="430" height="372" alt="image" src="https://github.com/user-attachments/assets/e475b6a2-758c-4e9d-aa9c-2035444bd6af" />


## get-ips.sh
- Get the primary IP for each interface. Attempts to filter out lo, docker, veth, br-, virbr interfaces. Works well on basic installs.
<img width="322" height="91" alt="image" src="https://github.com/user-attachments/assets/b2e1631b-73b3-4455-99aa-e0aec35729c9" />

## get-wan-ip.sh
- Dig for the WAN IP
<img width="410" height="102" alt="image" src="https://github.com/user-attachments/assets/26cd9546-efd0-49a0-a061-7ff19129f60a" />
