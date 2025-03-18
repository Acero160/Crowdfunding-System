// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);

}

contract CrowdfundingSystem {

    //Structs
    struct Campaign {
        address creator;
        uint goal; // Goal amount
        uint pledged; //Amount raised by the campaign
        uint32 startAt; // Start time of the campaign
        uint32 endAt; // End time of the campaign
        bool claimed; // Whether the creator has claimed the funds
    }


    //Variables
    uint public count; //Count of campaigns


    //Mapping
    mapping(uint => Campaign) public campaigns; //Store camapigns
    mapping (uint => mapping(address => uint)) public pledgedAmount; //Store pledged amount by user for a campaign

    //Events
    event Launch(uint id, address indexed creator, uint goal, uint startAt, uint endAt);
    event Cancel(uint id);
    event Pledge(uint _id, address indexed pledger, uint amount);
    event Unpledge(uint id, address indexed pledger, uint amount);
    event Claimed(uint id, uint pledged);
    event Refund (uint id, address indexed pledger, uint amount);

    IERC20 public immutable token;

    constructor(address _token) {
        token = IERC20(_token);
    }


    //Functions
    function launchCampaign (uint _goal, uint32 _startAt, uint32 _endAt) external {
        require (_startAt >= block.timestamp, "Crowdfunding System: Invalid start time");
        require (_endAt > _startAt, "Crowdfunding System: End time must be > than start time");
        require (_endAt <= block.timestamp + 90 days, "Crowdfunding System: Invalid end time");

        count = count + 1;
        campaigns [count] = Campaign (msg.sender, _goal, 0, _startAt, _endAt, false); 


        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    function cancelCampaign (uint _id) external {
        Campaign memory campaign = campaigns[_id];
        require(campaign.creator == msg.sender, "Crowdfunding System: Only creator can cancel the campaign");
        require (block.timestamp < campaign.startAt, "Crowdfunding System: Campaign has already started");

        delete campaigns[_id]; 

        emit Cancel(_id);
    }

    //Function to pledge funds to a campaign
    function pledge (uint _id, uint _amount) external {
        Campaign storage campaign = campaigns [_id];
        require (block.timestamp >= campaign.startAt, "Crowdfunding System: Campaign has not started yet");
        require (block.timestamp <= campaign.endAt, "Crowdfunding System: Campaign has ended");

        token.transferFrom (msg.sender, address(this), _amount);
        campaign.pledged += _amount;
        pledgedAmount [_id][msg.sender] += _amount;

        emit Pledge (_id, msg.sender, _amount);
    }

    //Function to unpledge funds from a campaign
    function unpledge (uint _id, uint _amount) external {
        Campaign storage campaign = campaigns [_id];
        require (block.timestamp <= campaign.endAt, "Crowdfunding System: Campaign has ended");

        uint pledged = pledgedAmount [_id][msg.sender];
        require (pledged >= _amount, "Crowdfunding System: Insufficient pledged amount");
        pledgedAmount [_id] [msg.sender] -= _amount;
        campaign.pledged -= _amount;

        token.transfer (msg.sender, _amount);

        emit Unpledge (_id, msg.sender, _amount);
    }

    //Function to claim the campaign funds
    function claim (uint _id) external {
        Campaign storage campaign = campaigns [_id];
        require (campaign.creator == msg.sender, "Crowdfunding System: Only creator can claim the funds");
        require (block.timestamp > campaign.endAt, "Crowdfunding System: Campaign has not ended yet");
        require(campaign.pledged >= campaign.goal, "Crowdfunding System: Campaign has not reached the goal");
        require(!campaign.claimed, "Crowdfunding System: Funds already claimed");

        campaign.claimed = true;

        token.transfer(campaign.creator, campaign.pledged);

        emit Claimed(_id, campaign.pledged);
    }

    //Function that allows contributors to withdraw their contributions if the campaign did not reach its goal
    function refund (uint _id) external {
        Campaign storage campaign = campaigns [_id];
        require(block.timestamp > campaign.endAt, "Crowdfunding System: Campaign has not ended yet");
        require (campaign.pledged < campaign.goal, "Crowdfunding System: Campaign has reached the goal");

        uint bal = pledgedAmount [_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;

        token.transfer(msg.sender, bal);

        emit Refund(_id, msg.sender, bal);
    }
    
}