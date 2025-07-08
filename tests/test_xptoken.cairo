use snforge_std::{
    declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_address,
    stop_cheat_caller_address,
};
use starknet::ContractAddress;
use axe::contracts::XPToken::{IXPTokenDispatcher, IXPTokenDispatcherTrait};
use openzeppelin_token::erc20::interface::{
    IERC20Dispatcher, IERC20DispatcherTrait, IERC20MetadataDispatcher,
    IERC20MetadataDispatcherTrait,
};
use openzeppelin_access::ownable::interface::{IOwnableDispatcher, IOwnableDispatcherTrait};

fn OWNER() -> ContractAddress {
    'OWNER'.try_into().unwrap()
}

fn USER() -> ContractAddress {
    'USER'.try_into().unwrap()
}

fn deploy_xp_token() -> (
    IXPTokenDispatcher, IERC20Dispatcher, IERC20MetadataDispatcher, IOwnableDispatcher,
) {
    let contract = declare("XPToken").unwrap().contract_class();
    let constructor_calldata = array![OWNER().into()];
    let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();

    let xp_token = IXPTokenDispatcher { contract_address };
    let erc20 = IERC20Dispatcher { contract_address };
    let metadata = IERC20MetadataDispatcher { contract_address };
    let ownable = IOwnableDispatcher { contract_address };

    (xp_token, erc20, metadata, ownable)
}

#[test]
fn test_token_metadata() {
    let (_, _, metadata, _) = deploy_xp_token();

    assert!(metadata.name() == "XP", "Token name should be XP");
    assert!(metadata.symbol() == "XP", "Token symbol should be XP");
}

#[test]
fn test_initial_supply() {
    let (_, erc20, _, _) = deploy_xp_token();

    assert!(erc20.total_supply() == 0, "Initial total supply should be 0");
    assert!(erc20.balance_of(OWNER()) == 0, "Owner initial balance should be 0");
    assert!(erc20.balance_of(USER()) == 0, "User initial balance should be 0");
}

#[test]
fn test_ownership() {
    let (_, _, _, ownable) = deploy_xp_token();

    assert!(ownable.owner() == OWNER(), "Owner should be correctly set");
}

#[test]
fn test_mint_by_owner() {
    let (xp_token, erc20, _, _) = deploy_xp_token();
    let mint_amount = 1000_u256;

    start_cheat_caller_address(xp_token.contract_address, OWNER());
    xp_token.mint(USER(), mint_amount);
    stop_cheat_caller_address(xp_token.contract_address);

    assert!(erc20.balance_of(USER()) == mint_amount, "User balance should equal mint amount");
    assert!(erc20.total_supply() == mint_amount, "Total supply should equal mint amount");
}

#[test]
fn test_multiple_mints_by_owner() {
    let (xp_token, erc20, _, _) = deploy_xp_token();
    let mint_amount_1 = 500_u256;
    let mint_amount_2 = 300_u256;

    start_cheat_caller_address(xp_token.contract_address, OWNER());
    xp_token.mint(USER(), mint_amount_1);
    xp_token.mint(OWNER(), mint_amount_2);
    stop_cheat_caller_address(xp_token.contract_address);

    assert!(
        erc20.balance_of(USER()) == mint_amount_1, "User balance should equal first mint amount",
    );
    assert!(
        erc20.balance_of(OWNER()) == mint_amount_2, "Owner balance should equal second mint amount",
    );
    assert!(
        erc20.total_supply() == mint_amount_1 + mint_amount_2,
        "Total supply should equal sum of mints",
    );
}

#[test]
#[should_panic(expected: ('Caller is not the owner',))]
fn test_mint_by_non_owner_should_fail() {
    let (xp_token, _, _, _) = deploy_xp_token();
    let mint_amount = 1000_u256;

    start_cheat_caller_address(xp_token.contract_address, USER());
    xp_token.mint(USER(), mint_amount);
    stop_cheat_caller_address(xp_token.contract_address);
}

#[test]
fn test_transfer_ownership() {
    let (xp_token, _, _, ownable) = deploy_xp_token();

    start_cheat_caller_address(xp_token.contract_address, OWNER());
    ownable.transfer_ownership(USER());
    stop_cheat_caller_address(xp_token.contract_address);

    assert!(ownable.owner() == USER(), "Ownership should be transferred to user");
}

#[test]
fn test_mint_after_ownership_transfer() {
    let (xp_token, erc20, _, ownable) = deploy_xp_token();
    let mint_amount = 1000_u256;

    // Transfer ownership first
    start_cheat_caller_address(xp_token.contract_address, OWNER());
    ownable.transfer_ownership(USER());
    stop_cheat_caller_address(xp_token.contract_address);

    // Now USER is the owner and should be able to mint
    start_cheat_caller_address(xp_token.contract_address, USER());
    xp_token.mint(USER(), mint_amount);
    stop_cheat_caller_address(xp_token.contract_address);

    assert!(erc20.balance_of(USER()) == mint_amount, "User balance should equal mint amount");
    assert!(erc20.total_supply() == mint_amount, "Total supply should equal mint amount");
}

#[test]
fn test_burn_by_owner() {
    let (xp_token, erc20, _, _) = deploy_xp_token();
    let mint_amount = 1000_u256;
    let burn_amount = 400_u256;

    start_cheat_caller_address(xp_token.contract_address, OWNER());
    xp_token.mint(USER(), mint_amount);
    stop_cheat_caller_address(xp_token.contract_address);

    start_cheat_caller_address(xp_token.contract_address, OWNER());
    xp_token.burn(USER(), burn_amount);
    stop_cheat_caller_address(xp_token.contract_address);

    assert!(
        erc20.balance_of(USER()) == mint_amount - burn_amount,
        "User balance should decrease by burn amount",
    );
    assert!(
        erc20.total_supply() == mint_amount - burn_amount,
        "Total supply should decrease by burn amount",
    );
}

#[test]
#[should_panic(expected: ('Caller is not the owner',))]
fn test_burn_by_non_owner_should_fail() {
    let (xp_token, _, _, _) = deploy_xp_token();
    let mint_amount = 1000_u256;
    let burn_amount = 100_u256;

    start_cheat_caller_address(xp_token.contract_address, OWNER());
    xp_token.mint(USER(), mint_amount);
    stop_cheat_caller_address(xp_token.contract_address);

    start_cheat_caller_address(xp_token.contract_address, USER());
    xp_token.burn(USER(), burn_amount);
    stop_cheat_caller_address(xp_token.contract_address);
}

#[test]
#[should_panic]
fn test_burn_more_than_balance_should_fail() {
    let (xp_token, _, _, _) = deploy_xp_token();
    let mint_amount = 100_u256;
    let burn_amount = 200_u256;

    start_cheat_caller_address(xp_token.contract_address, OWNER());
    xp_token.mint(USER(), mint_amount);
    stop_cheat_caller_address(xp_token.contract_address);

    start_cheat_caller_address(xp_token.contract_address, OWNER());
    xp_token.burn(USER(), burn_amount);
    stop_cheat_caller_address(xp_token.contract_address);
}
