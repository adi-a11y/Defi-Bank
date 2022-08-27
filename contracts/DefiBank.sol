pragma solidity 0.8.6;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}



contract DefiBank{
    string public name = "Defi Bank";

    address public usdc;
    address public InterestToken;

    address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor() public {
        usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        InterestToken = 0x1F7F9d4edaA2c7024f3EB260662B1D25Da5f80C5;
    }

    // Allowing the user to stake usdc tokens

    function stakeTokens(uint _amount) public {
        // Transfer usdc to this contract for staking
        IERC20(usdc).transferFrom(msg.sender,address(this),_amount);

        // Updating the staking balance
        stakingBalance[msg.sender] += _amount;

        // Add the user to stakers array if not added
        if(!hasStaked[msg.sender]){
            stakers.push(msg.sender);
        }         
        // update staking status
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    // Allowing the user to unstake

    function unstakeTokens(uint _amount) public {

        // Get the balance of the user
        uint balanceOfUser = stakingBalance[msg.sender];

        // withdrawal amount should be less than or equal to staking balance
        require(_amount<=balanceOfUser);

        // transfer usdc tokens out of this contact to the person who wishes to withdraw
        IERC20(usdc).transfer(msg.sender,_amount);

        // updating

        stakingBalance[msg.sender] -= _amount;
        if(stakingBalance[msg.sender]==0){
            isStaking[msg.sender] = false;
        } 
    }

    // Issue the "Interest token" (INT) as a reward for staking

    function issueInterestToken() public {
        for(uint i=0;i<stakers.length;i++){
            address recipient = stakers[i];
            uint balance  = stakingBalance[recipient];
        
            if(balance>0){
                IERC20(InterestToken).transfer(recipient,balance);
            }
        }

    }



}