// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @author: manifold.xyz

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

/**
 * Core creator contract interface
 */
interface IERC721CreatorCore is IERC165 {

    event ExtensionRegistered(address indexed extension, address indexed sender);
    event ExtensionUnregistered(address indexed extension, address indexed sender);
    event ExtensionBlacklisted(address indexed extension, address indexed sender);
    event MintPermissionsUpdated(address indexed extension, address indexed permissions, address indexed sender);
    event RoyaltiesUpdated(uint256 indexed tokenId, address payable[] receivers, uint256[] basisPoints);
    event DefaultRoyaltiesUpdated(address payable[] receivers, uint256[] basisPoints);
    event ExtensionRoyaltiesUpdated(address indexed extension, address payable[] receivers, uint256[] basisPoints);

    /**
     * @dev gets address of all extensions
     */
    function getExtensions() external view returns (address[] memory);

    /**
     * @dev add an extension.  Can only be called by contract owner or admin.
     * extension address must point to a contract implementing IERC721CreatorExtension.
     * Returns True if newly added, False if already added.
     */
    function registerExtension(address extension, string calldata baseURI) external;

    /**
     * @dev add an extension.  Can only be called by contract owner or admin.
     * extension address must point to a contract implementing IERC721CreatorExtension.
     * Returns True if newly added, False if already added.
     */
    function registerExtension(address extension, string calldata baseURI, bool baseURIIdentical) external;

    /**
     * @dev add an extension.  Can only be called by contract owner or admin.
     * Returns True if removed, False if already removed.
     */
    function unregisterExtension(address extension) external;

    /**
     * @dev blacklist an extension.  Can only be called by contract owner or admin.
     * This function will destroy all ability to reference the metadata of any tokens created
     * by the specified extension. It will also unregister the extension if needed.
     * Returns True if removed, False if already removed.
     */
    function blacklistExtension(address extension) external;

    /**
     * @dev set the baseTokenURI of an extension.  Can only be called by extension.
     */
    function setBaseTokenURIExtension(string calldata uri) external;

    /**
     * @dev set the baseTokenURI of an extension.  Can only be called by extension.
     * For tokens with no uri configured, tokenURI will return "uri+tokenId"
     */
    function setBaseTokenURIExtension(string calldata uri, bool identical) external;

    /**
     * @dev set the common prefix of an extension.  Can only be called by extension.
     * If configured, and a token has a uri set, tokenURI will return "commonURI+tokenURI"
     * Useful if you want to use ipfs/arweave
     */
    function setTokenURIPrefixExtension(string calldata prefix) external;

    /**
     * @dev set the tokenURI of a token extension.  Can only be called by extension that minted token.
     */
    function setTokenURIExtension(uint256 tokenId, string calldata uri) external;

    /**
     * @dev set the tokenURI of a token extension for multiple tokens.  Can only be called by extension that minted token.
     */
    function setTokenURIExtension(uint256[] memory tokenId, string[] calldata uri) external;

    /**
     * @dev set the baseTokenURI for tokens with no extension.  Can only be called by owner/admin.
     * For tokens with no uri configured, tokenURI will return "uri+tokenId"
     */
    function setBaseTokenURI(string calldata uri) external;

    /**
     * @dev set the common prefix for tokens with no extension.  Can only be called by owner/admin.
     * If configured, and a token has a uri set, tokenURI will return "commonURI+tokenURI"
     * Useful if you want to use ipfs/arweave
     */
    function setTokenURIPrefix(string calldata prefix) external;

    /**
     * @dev set the tokenURI of a token with no extension.  Can only be called by owner/admin.
     */
    function setTokenURI(uint256 tokenId, string calldata uri) external;

    /**
     * @dev set the tokenURI of multiple tokens with no extension.  Can only be called by owner/admin.
     */
    function setTokenURI(uint256[] memory tokenIds, string[] calldata uris) external;

    /**
     * @dev set a permissions contract for an extension.  Used to control minting.
     */
    function setMintPermissions(address extension, address permissions) external;

    /**
     * @dev mint a token with no extension. Can only be called by an admin.
     * Returns tokenId minted
     */
    function mintBase(address to) external returns (uint256);

    /**
     * @dev mint a token with no extension. Can only be called by an admin.
     * Returns tokenId minted
     */
    function mintBase(address to, string calldata uri) external returns (uint256);

    /**
     * @dev batch mint a token with no extension. Can only be called by an admin.
     * Returns tokenId minted
     */
    function mintBaseBatch(address to, uint16 count) external returns (uint256[] memory);

    /**
     * @dev batch mint a token with no extension. Can only be called by an admin.
     * Returns tokenId minted
     */
    function mintBaseBatch(address to, string[] calldata uris) external returns (uint256[] memory);

    /**
     * @dev mint a token. Can only be called by a registered extension.
     * Returns tokenId minted
     */
    function mintExtension(address to) external returns (uint256);

    /**
     * @dev mint a token. Can only be called by a registered extension.
     * Returns tokenId minted
     */
    function mintExtension(address to, string calldata uri) external returns (uint256);

    /**
     * @dev batch mint a token. Can only be called by a registered extension.
     * Returns tokenIds minted
     */
    function mintExtensionBatch(address to, uint16 count) external returns (uint256[] memory);

    /**
     * @dev batch mint a token. Can only be called by a registered extension.
     * Returns tokenId minted
     */
    function mintExtensionBatch(address to, string[] calldata uris) external returns (uint256[] memory);

    /**
     * @dev burn a token. Can only be called by token owner or approved address.
     * On burn, calls back to the registered extension's onBurn method
     */
    function burn(uint256 tokenId) external;

    /**
     * @dev get the extension of a given token
     */
    function tokenExtension(uint256 tokenId) external view returns (address);

    /**
     * @dev Set default royalties
     */
    function setRoyalties(address payable[] calldata receivers, uint256[] calldata basisPoints) external;

    /**
     * @dev Set royalties of a token
     */
    function setRoyalties(uint256 tokenId, address payable[] calldata receivers, uint256[] calldata basisPoints) external;

    /**
     * @dev Set royalties of an extension
     */
    function setRoyaltiesExtension(address extension, address payable[] calldata receivers, uint256[] calldata basisPoints) external;

    /**
     * @dev Get royalites of a token.  Returns list of receivers and basisPoints
     */
    function getRoyalties(uint256 tokenId) external view returns (address payable[] memory, uint256[] memory);
    
    function getFeeRecipients(uint256 id) external view returns (address payable[] memory);
    function getFeeBps(uint256 id) external view returns (uint[] memory);

}