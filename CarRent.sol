// SPDX-License-Identifier: MIT                                                                               
                                                    
pragma solidity ^0.8.9;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


contract Ownable {
    address private _owner;

    event OwnershipRenounced(address indexed previousOwner);
    event TransferOwnerShip(address indexed previousOwner);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = msg.sender;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, 'Not owner');
        _;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipRenounced(_owner);
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        emit TransferOwnerShip(newOwner);
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0),
            'Owner can not be 0');
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Car is Ownable {

    using Address for address;
    address carRent;

    struct SpecialTime {
        bool bookingAvailable; // first check if this is TRUE. If not then allow to book with this special price. If not then user can't book this car for this time.

        uint256 startTime;
        uint256 endTime;
        uint256 price;
    }

    uint256 public basePrice; // This is the base price for charging vehicles
    uint256 public deliveryPrice; // This is the price for delivery of vehicle to doorstep
    uint256 public securityDeposit;

    // Only one of these discount will be applied at a time
    uint256 public weeklyDiscount; // This value is in %, 10% = 10. If the rent time is more than equal to 7 days then we provide this value percent as a discount
    uint256 public monthlyDiscount; // This value is in percent. If the rent time is more than 30 days then apply this value percent as a discount

    uint256 public bookingWindow; // This value is number of days from current time for which user can book the car. If its 0 then the car is not available for booking by default and only special days can be booked.
    uint256 public cancelationCharges; // This value is in percent. If the user cancels the booking then this percent of the total booking amount will be deducted from the user's wallet and the rest will be refunded to the user.
    uint256 public minimumTripLength;
    uint256 public maximumTripLength;

    uint8 public verificationStatus; // 0 = not listed, 1 = verified and listed, 2 = rejected and not listed, 3 = in queue and not listed

    SpecialTime[] public specialTimes;
    Booking [] bookedList;
    Booking [] allBookings; // this will be used on frontend to display all the bookings of the car

    mapping (address => uint256) public tokenPrice; // this is the price in terms of the token for the booking
    address public tokenAllowed; // this is the mapping for tokens allowed to rent car

    bool public cancelationsAllowed;
    bool public reservationRequestRequired;
    

    constructor (uint256 _basePrice, uint256 _deliveryPrice, uint256 _securityDeposit, uint256 _weeklyDiscount, uint256 _monthlyDiscount, uint256 _bookingWindow, uint256 _cancelationCharges, uint256 _minimumTripLength, uint256 _maximumTripLength, bool _cancelationsAllowed, bool _reservationRequestRequired, uint8 _verificationStatus, address _token, address _carRent) {
        basePrice = _basePrice;
        deliveryPrice = _deliveryPrice;
        securityDeposit = _securityDeposit;
        weeklyDiscount = _weeklyDiscount;
        monthlyDiscount = _monthlyDiscount;
        bookingWindow = _bookingWindow;
        cancelationCharges = _cancelationCharges;
        minimumTripLength = _minimumTripLength;
        maximumTripLength = _maximumTripLength;
        cancelationsAllowed = _cancelationsAllowed;
        reservationRequestRequired = _reservationRequestRequired;
        verificationStatus = _verificationStatus;
        tokenAllowed = _token;
        carRent = _carRent;
        transferOwnership(msg.sender);
    }

    // this function returns cost if the booking can be confirmed
    function bookCar (uint256 _startTime, uint256 _endTime) public returns (address) {
        require (checkCarAvailability(_startTime, _endTime) == true, "Car is not available for booking in this time duration");
        uint256 _cost = estimateCost(_startTime, _endTime);
        uint256 _bookingStatus = 0;
        if (reservationRequestRequired == true) {
            _bookingStatus = 3;
        }
        uint256 _serviceFee = _cost * CarRent(carRent).serviceFee() / 100;
        Booking _booking = new Booking(_cost, securityDeposit, _serviceFee, _startTime, _endTime, _bookingStatus, msg.sender, carRent);
        bookedList.push(_booking);
        allBookings.push(_booking);


        safeTransferFrom(IERC20(tokenAllowed), tx.origin, address(_booking), _cost + securityDeposit + _serviceFee);

        return address(_booking);
    }


    function removeOldBookings () public {
        uint256 i = 0;
        for (i = bookedList.length -1 ; i >=0; i--) {
            if (block.timestamp > bookedList[i].endTime() || bookedList[i].bookingStatus() == 1 || bookedList[i].bookingStatus() == 2 || bookedList[i].bookingStatus() == 4) {
                bookedList[i] = bookedList[bookedList.length -1];
                bookedList.pop();
            }
        }
    }

    function checkCarAvailability (uint256 _startTime, uint256 _endTime) public view returns (bool) {
        // check if the car is available for booking
        uint256 i =0;
        for (i= 0; i< bookedList.length; i++) {
            if (bookedList[i].bookingStatus() == 1 || bookedList[i].bookingStatus() == 2) {
                continue;
            }
            if ((_startTime <= bookedList[i].startTime() && bookedList[i].startTime() <= _endTime) ||
            (_startTime <= bookedList[i].endTime() && bookedList[i].endTime() <= _endTime)) {
                // car is not available for booking
                return false;
            }
        }

        // check if the car is available for booking in special times
        for (i= 0; i< specialTimes.length; i++) {
            if ((_startTime <= specialTimes[i].startTime && specialTimes[i].startTime <= _endTime) ||
            (_startTime <= specialTimes[i].endTime && specialTimes[i].endTime <= _endTime)) {
                // car is not available for booking
                return false;
            }
        }
        return true;
    }

    function estimateCost (uint256 _startTime, uint256 _endTime) public view returns (uint256) {
        // check if the car is available for booking in special times
        uint256 _days = (_endTime - _startTime) / 1 days;
        if (_days * 1 days != (_endTime - _startTime)) {
            _days ++;
        }
        require (_endTime < block.timestamp + bookingWindow * 1 days, "Booking window is not in range");
        require (_days < minimumTripLength || _days > maximumTripLength, "Trip length is not in range");

        uint256 _cost = _days * basePrice;

        if (_days >= 30 && monthlyDiscount > 0){
            _cost = _cost * (100 - monthlyDiscount) / 100;
        } else if (_days >= 7 && weeklyDiscount > 0) {
            _cost = _cost * (100 - weeklyDiscount) / 100;
        }

        uint256 i =0;
        uint256 _discountDays = 0;
        for (i= 0; i< specialTimes.length; i++) {
            if (specialTimes[i].bookingAvailable == true) {
                if ((specialTimes[i].startTime <= _startTime && specialTimes[i].endTime <= _endTime)) {
                    _discountDays = (specialTimes[i].endTime - _startTime) / 1 days;
                } else if (_startTime <= specialTimes[i].startTime && _endTime <= specialTimes[i].endTime) {
                    _discountDays = (_endTime - specialTimes[i].startTime) / 1 days;
                } else if (_startTime <= specialTimes[i].startTime && _endTime >= specialTimes[i].endTime) {
                    _discountDays = (specialTimes[i].endTime - specialTimes[i].startTime) / 1 days;
                } else if (_startTime >= specialTimes[i].startTime && _endTime <= specialTimes[i].endTime) {
                    _discountDays = (_endTime - _startTime) / 1 days;
                } else {
                    // car is not available for booking
                    revert("Car is not available for booking");
                }
            }
        }
        _cost = _cost - ((_discountDays * basePrice * specialTimes[i].price)/ 100);
        return 0;
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
    }

    // all OnlyOwner functions here

    function addSpecialTime (uint256 _startTime, uint256 _endTime, uint256 _price, bool _bookingAvailable) public onlyOwner() {
        specialTimes.push(SpecialTime(_bookingAvailable, _endTime, _price, _startTime));
    }

    function setReservationRequestRequired (bool _reservationRequestRequired) public onlyOwner() {
        reservationRequestRequired = _reservationRequestRequired;
    }

    function setCancelationsAllowed (bool _cancelationsAllowed) public onlyOwner() {
        cancelationsAllowed = _cancelationsAllowed;
    }

    function setVerificationStatus (uint8 _verificationStatus) public onlyOwner() {
        verificationStatus = _verificationStatus;
    }

    function setBasePrice (uint256 _basePrice) public onlyOwner() {
        basePrice = _basePrice;
    }

    function setDeliveryPrice (uint256 _deliveryPrice) public onlyOwner() {
        deliveryPrice = _deliveryPrice;
    }

    function setSecurityDeposit (uint256 _securityDeposit) public onlyOwner() {
        securityDeposit = _securityDeposit;
    }

    function setWeeklyDiscount (uint256 _weeklyDiscount) public onlyOwner() {
        weeklyDiscount = _weeklyDiscount;
    }

    function setMonthlyDiscount (uint256 _monthlyDiscount) public onlyOwner() {
        monthlyDiscount = _monthlyDiscount;
    }

    function setBookingWindow (uint256 _bookingWindow) public onlyOwner() {
        bookingWindow = _bookingWindow;
    }

    function setCancelationCharges (uint256 _cancelationCharges) public onlyOwner() {
        cancelationCharges = _cancelationCharges;
    }

    function setMinimumTripLength (uint256 _minimumTripLength) public onlyOwner() {
        minimumTripLength = _minimumTripLength;
    }

    function setMaximumTripLength (uint256 _maximumTripLength) public onlyOwner() {
        maximumTripLength = _maximumTripLength;
    }

    function setTokenPrice (address _token, uint256 _tokenPrice) public onlyOwner() {
        tokenPrice[_token] = _tokenPrice;
    }

    // all public functions here

    function getSpecialTimesLength () public view returns (uint256) {
        return specialTimes.length;
    }

}

contract User is Ownable {

    using Address for address;
    address public carRentAddress;

    Booking [] public myBookings; // this is the list of car bookings for which I have booked a car from platform
    Car [] public myListedCars;

    constructor (address _owner) {
        carRentAddress = msg.sender;
        transferOwnership(_owner);
    }

    function publishVehicle (uint256 _basePrice, uint256 _deliveryPrice, uint256 _securityDeposit, uint256 _weeklyDiscount, uint256 _monthlyDiscount, uint256 _bookingWindow, uint256 _cancelationCharges, uint256 _minimumTripLength, uint256 _maximumTripLength, bool _cancelationsAllowed, bool _reservationRequestRequired, uint8 _verificationStatus, address _tokenAllowed) public {
        require (msg.sender == carRentAddress , 'use router');
        Car car_ = new Car(_basePrice, _deliveryPrice, _securityDeposit, _weeklyDiscount, _monthlyDiscount, _bookingWindow, _cancelationCharges, _minimumTripLength, _maximumTripLength, _cancelationsAllowed, _reservationRequestRequired, _verificationStatus, _tokenAllowed, carRentAddress);
        
        myListedCars.push(car_);
    }

    function unlistCar (address _car) public onlyOwner() {
        require (msg.sender == carRentAddress , 'use router');
        Car car_ = Car(_car);
        require(car_.owner() == address(this), 'Not owner of car');
        require (car_.verificationStatus() == 1, "Car already not listed, rejected or pending");

        car_.setVerificationStatus(0);
    }

    function listCar (address _car) public onlyOwner() {
        require (msg.sender == carRentAddress , 'use router');
        Car car_ = Car(_car);
        require(car_.owner() == address(this), 'Not owner of car');
        require (car_.verificationStatus() == 0, "Car already listed, rejected or pending");

        car_.setVerificationStatus(1);
    }

    function authoriseCar (address _car, uint8 _flag) public {
        require (msg.sender == carRentAddress , 'use router');
        Car car_ = Car(_car);
        require(car_.owner() == address(this), 'Not owner of car');

        car_.setVerificationStatus(_flag);
    }

    function bookCar (uint256 _startTime, uint256 _endTime, address _car) public {
        require (msg.sender == owner() || msg.sender == carRentAddress , 'Not owner of car');
        Car car_ = Car(_car);
        address _booking = car_.bookCar(_startTime, _endTime);

        myBookings.push(Booking(_booking));
    }

    

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
    }


}


contract Booking is Ownable {

    using Address for address;
    address public carRent;

    uint256 public amount;
    uint256 public securityDeposit;
    uint256 public serviceFee;
    uint256 public startTime;
    uint256 public endTime;
    uint256 public bookingTime;
    uint256 public bookingStatus; // 0 - confirmed, 1 - ride completed, 2 - cancelled, 3 - pending, 4 - noRefund

    address public car;
    address public user;

    constructor (uint256 _amount, uint256 _securityDeposit, uint256 _serviceFee, uint256 _startTime, uint256 _endTime, uint256 _bookingStatus, address _user, address _carRent) {
        amount = _amount;
        securityDeposit = _securityDeposit;
        serviceFee = _serviceFee;
        startTime = _startTime;
        endTime = _endTime;
        bookingTime = block.timestamp;
        bookingStatus = _bookingStatus;
        user = _user;
        carRent = _carRent;
        car = msg.sender;
    }

    function setBookingStatus (uint256 _bookingStatus) public {
        require (msg.sender == carRent, "You cant setbooking");
        if (_bookingStatus == 1){
            require (endTime <= block.timestamp, "endTime must be completed");
            Car car_ = Car(car);
            address _tokenAllowed = car_.tokenAllowed();
            address _carOwner = car_.owner();
            address _userAddress = User(user).owner();

            safeTransferFrom(IERC20(_tokenAllowed), address(this), _userAddress, amount);
            safeTransferFrom(IERC20(_tokenAllowed), address(this), _carOwner, securityDeposit);
            safeTransferFrom(IERC20(_tokenAllowed), address(this), CarRent(carRent).serviceFeeWallet(), serviceFee);
        } else if (_bookingStatus == 2) {
            require (startTime >= block.timestamp, "endTime must be completed");
            Car car_ = Car(car);
            address _carOwner = car_.owner();
            address _tokenAllowed = car_.tokenAllowed();
            address _userAddress = User(user).owner();
            uint256 _cancelationCharges = amount * Car(car).cancelationCharges();
            uint256 _amount = amount - _cancelationCharges;

            safeTransferFrom(IERC20(_tokenAllowed), address(this), _userAddress, _amount + securityDeposit + serviceFee);
            safeTransferFrom(IERC20(_tokenAllowed), address(this), _carOwner, _cancelationCharges);
        } else if (_bookingStatus == 4){
            require (startTime >= block.timestamp, "endTime must be completed");
            Car car_ = Car(car);
            address _tokenAllowed = car_.tokenAllowed();
            address _carOwner = car_.owner();

            safeTransferFrom(IERC20(_tokenAllowed), address(this), CarRent(carRent).serviceFeeWallet(), serviceFee);
            safeTransferFrom(IERC20(_tokenAllowed), address(this), _carOwner, amount + securityDeposit);
        }
        bookingStatus = _bookingStatus;
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
    }

}

contract CarRent is Ownable {

    using Address for address;
    bool public carListingOpenForEveryone;

    uint256 public serviceFee; // This is the fee that we charge for every booking. This value is in %. Final service amount is calculated by (basePrice * rentTime * serviceFee)/100
    address public serviceFeeWallet;

    mapping (address => bool) public verfiedCustomers; // if car listing is not open for everyone then only verified customers can book cars. Or else the booking will go on a waiting list and will be approved by the admin.
    mapping (address => bool) public isAdmin;
    mapping (address => bool) public carStatus; // This is for the admin to blacklist a car if they find wrong details or something
    mapping (address => address) public userMapping; // This is to get the address of user contract from the address of user

    // Queue for allowing the listing to be approved
    Car [] public carListingQueue;

    Car [] public cars;
    User [] public users;


    modifier onlyAdmin() {
        require(isAdmin[msg.sender], 'Not admin');
        _;
    }

    function addUser () public {
        User user_ = new User(msg.sender);
        users.push(user_);
        userMapping[msg.sender] = address(user_);
    }

    function publishVehicle(uint256 _basePrice, uint256 _deliveryPrice, uint256 _securityDeposit, uint256 _weeklyDiscount, uint256 _monthlyDiscount, uint256 _bookingWindow, uint256 _cancelationCharges, uint256 _minimumTripLength, uint256 _maximumTripLength, bool _cancelationsAllowed, bool _reservationRequestRequired, address _tokenAllowed) public {
        User user_ = User(userMapping[msg.sender]);
        uint8 _verificationStatus = 0;
        if (carListingOpenForEveryone || verfiedCustomers[msg.sender]) _verificationStatus = 1;
        else _verificationStatus = 3;
        user_.publishVehicle(_basePrice, _deliveryPrice, _securityDeposit, _weeklyDiscount, _monthlyDiscount, _bookingWindow, _cancelationCharges, _minimumTripLength, _maximumTripLength, _cancelationsAllowed, _reservationRequestRequired, _verificationStatus, _tokenAllowed);
    }

    function unlistCar (address _car) public {
        User user_ = User(userMapping[msg.sender]);
        user_.unlistCar(_car);
    }

    function listCar (address _car) public {
        User user_ = User(userMapping[msg.sender]);
        user_.listCar(_car);
    }

    function authoriseCar (address _car, uint8 _flag) public {
        require (msg.sender == owner() || isAdmin[msg.sender], 'Not admin');
        User user_ = User(userMapping[msg.sender]);
        user_.authoriseCar(_car, _flag);
    }

    function bookCar (uint256 _startTime, uint256 _endTime, address _car) public {
        User user_ = new User(msg.sender);
        user_.bookCar(_startTime, _endTime, _car);

    }

    function reviewPendingBooking (address _booking, uint256 _flag) public {
        require (User(Car(Booking(_booking).car()).owner()).owner() == msg.sender, "only car owner can change booking status");
        require (_flag != 4, "contact admins if you want to claim security deposit");
        Booking booking_ = Booking(_booking);
        require(booking_.user() == address(this), 'Not owner of booking');

        booking_.setBookingStatus(_flag);
    }

    function reviewSpecialBooking (address _booking, uint256 _flag) public {
        require (isAdmin[msg.sender], "contact admins if you want to claim security deposit");
        Booking booking_ = Booking(_booking);
        require(booking_.user() == address(this), 'Not owner of booking');

        booking_.setBookingStatus(_flag);
    } 

    function cancelBooking (address _booking) public {
        require (msg.sender == User(Booking(_booking).user()).owner(), "you don't have this booking");
        require ((Car(Booking(_booking).car()).cancelationsAllowed()), "You can't cancel this booking");
        Booking booking_ = Booking(_booking);

        booking_.setBookingStatus(2);
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
    }

    // Only owner functions here ---------------------------

    function addAdmin (address _admin) public onlyOwner() {
        isAdmin[_admin] = true;
    }

    function removeAdmin (address _admin) public onlyOwner() {
        isAdmin[_admin] = false;
    }

    function setServiceFeeWallet (address _wallet) public onlyOwner(){
        serviceFeeWallet = _wallet;
    }

    function setServiceFee (uint _fee) public onlyOwner() {
        serviceFee = _fee;
    }

}