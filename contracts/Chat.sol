//SPDC-License-Identifier : UNLISENCED

pragma solidity ^0.8.9;

contract chatApp{

    struct friend {
        address friendAddress;
        string name;
    } 
    struct user{
        string name;
        friend[] friendList;
    }
    struct allUsersStruct{
        string userName;
        address userAddress;
    }
    struct message{
        address sender;
        uint timestamp;
        string text;
    }

    allUsersStruct[] allUsers;
    mapping(address=>user) userList;
    mapping(bytes32 => message[]) allMessages;

    function checkUser(address _address) public view returns(bool){
        return bytes(userList[_address].name).length>0;
    }

    function createAccount(string calldata _name) external{
        require(bytes(_name).length>0,"Veuillez donnez un nom pas vide");
        require(checkUser(msg.sender)==false,"Vous avez deja un compte ");

        userList[msg.sender].name=_name;
        allUsers.push(allUsersStruct(_name,msg.sender));
    }

    function getUser(address _address) public view returns(string memory){
        require(checkUser(_address),"Cet utilisateur n'existe pas");

        return userList[_address].name;
    }

    function _checkFriendsAlready(address _add1,address _add2) internal view returns(bool){
         for(uint i=0;i<userList[_add1].friendList.length;i++){
            if(userList[_add1].friendList[i].friendAddress==_add2){
                return true;
            }
            
        }
        return false;
    }

    function addFriend(address _friendAddress, string calldata _friendName) external{
        require(checkUser(_friendAddress),"le compte d'ami n'existe pas");
        require(checkUser(msg.sender),"vous devez creer un compte avant dd'ajouteer des amis");
        require(bytes(_friendName).length>0,"Donnez un nom valide SVP! ");
        require(_checkFriendsAlready(msg.sender, _friendAddress)==false,"Vous etes deja amis avec cet utilisateur");

        friend memory nwFriend=friend(_friendAddress,_friendName);

        userList[msg.sender].friendList.push(nwFriend);
    }

    function getMyFriendsList() external view returns(friend[] memory){
        return userList[msg.sender].friendList; 
    }

    function _getChatCode(address _add1,address _add2) internal pure returns(bytes32){
        if(_add1>_add2){
            return keccak256(abi.encodePacked(_add1,_add2));
        }
        else{
            return keccak256(abi.encodePacked(_add2,_add1));
        }
    }
    function sendMeessage(address _friendAddress,string calldata _msg) external{
        require(checkUser(_friendAddress), "l'addresse de votre ami il a pas de compte");
        require(checkUser(msg.sender), "vous devez creer un compte");
        require(_checkFriendsAlready(msg.sender, _friendAddress),"vous n'etees pas ami");

        bytes32 chatCode=_getChatCode(msg.sender, _friendAddress);
        message memory newMsg=message(msg.sender,block.timestamp,_msg);
        allMessages[chatCode].push(newMsg);

    }
    function readMessages(address _friendAddress) public view returns(message[] memory){
        require(checkUser(_friendAddress), "l'addresse de votre ami il a pas de compte");
        require(checkUser(msg.sender), "vous devez creer un compte"); 
        bytes32 chatCode=_getChatCode(msg.sender, _friendAddress);
        return allMessages[chatCode];
    }

    function getAllUsers() public view returns(allUsersStruct[] memory){
        return allUsers;
    }

    function test()public pure returns(uint){
        return 20;
    }



}