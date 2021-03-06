$:.unshift(Dir.pwd + "/lib")
require 'rubygems'
require 'benchmark'
require 'hpricot'
require 'rexml/document'
require 'xml'


# Taken from http://depixelate.com/2008/4/23/ruby-xml-parsing-benchmarks

XML_STRING = DATA.read

class Parse
  def self.libxml
    doc = XML::Parser.string(XML_STRING).parse
    ary = []
    doc.find('/*/*/*').each do |node|
      case node.name
      when 'ItemQueryRs'
        node.each_element do |child|
          ary << child.find_first('./ListID')
        end
      end
    end
    ary
  end
  
  def self.rexml
    doc = REXML::Document.new(XML_STRING)
    ary = []
    REXML::XPath.each(doc, '/*/*/*') do |node|
      case node.name
      when 'ItemQueryRs'
        node.elements.each do |element|
          ary << rexml_fetch(element, 'ListID')
        end
      end
    end
    ary
  end
  
  def self.hpricot
    doc = Hpricot.XML(XML_STRING)
    ary = []
    response_element = doc.search('/*/*/*').each do |node|
      next unless node.elem?
      case node.name
      when 'ItemQueryRs'
        node.containers.each do |element|
          ary << hpricot_fetch(element/'ListID')
        end
      end
    end
    ary
  end
  
  # rexml helper
  def self.rexml_fetch(node, name)
    e = REXML::XPath.first(node, name)
    e ? e.text : nil
  end
  
  # hpricot helper
  def self.hpricot_fetch(path)
    return nil if path.nil? || path.empty?
    path = path.first if path.is_a?(Array)
    path.innerHTML
  end
end

TIMES = 100
Benchmark.bmbm do |x|
  x.report('libxml') { TIMES.times { Parse.libxml } }
  x.report('Hpricot') { TIMES.times { Parse.hpricot } }
  x.report('REXML') { TIMES.times { Parse.rexml } }
end

__END__
<?xml version="1.0"?>
<QBXML>
  <QBXMLMsgsRs>
    <ItemQueryRs requestID="1" statusCode="0" statusSeverity="Info" statusMessage="Status OK">
      <ItemServiceRet>
        <ListID>240000-1071531214</ListID>
        <TimeCreated>2003-12-15T15:33:34-08:00</TimeCreated>
        <TimeModified>2003-12-15T15:34:51-08:00</TimeModified>
        <EditSequence>1071531291</EditSequence>
        <Name>Delivery</Name>
        <FullName>Delivery</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>20000-999021789</ListID>
          <FullName>Non</FullName>
        </SalesTaxCodeRef>
        <SalesOrPurchase>
          <Desc>Delivery Service Fee (free for orders over $100)</Desc>
          <Price>15.00</Price>
          <AccountRef>
            <ListID>610001-1071531179</ListID>
            <FullName>Service</FullName>
          </AccountRef>
        </SalesOrPurchase>
      </ItemServiceRet>
      <ItemServiceRet>
        <ListID>10000-934380927</ListID>
        <TimeCreated>1999-08-11T07:15:27-08:00</TimeCreated>
        <TimeModified>1999-08-11T07:15:27-08:00</TimeModified>
        <EditSequence>934380927</EditSequence>
        <Name>Design</Name>
        <FullName>Design</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>20000-999021789</ListID>
          <FullName>Non</FullName>
        </SalesTaxCodeRef>
        <SalesOrPurchase>
          <Desc>Custom Landscape Design</Desc>
          <Price>55.00</Price>
          <AccountRef>
            <ListID>150000-934380913</ListID>
            <FullName>Landscaping Services:Design Services</FullName>
          </AccountRef>
        </SalesOrPurchase>
      </ItemServiceRet>
      <ItemServiceRet>
        <ListID>20000-934380927</ListID>
        <TimeCreated>1999-08-11T07:15:27-08:00</TimeCreated>
        <TimeModified>1999-08-11T08:59:12-08:00</TimeModified>
        <EditSequence>934387152</EditSequence>
        <Name>Gardening</Name>
        <FullName>Gardening</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>20000-999021789</ListID>
          <FullName>Non</FullName>
        </SalesTaxCodeRef>
        <SalesOrPurchase>
          <Desc>Weekly gardening services</Desc>
          <Price>0.00</Price>
          <AccountRef>
            <ListID>1F0000-934380913</ListID>
            <FullName>Landscaping Services:Labor:Installation</FullName>
          </AccountRef>
        </SalesOrPurchase>
      </ItemServiceRet>
      <ItemServiceRet>
        <ListID>30000-934380927</ListID>
        <TimeCreated>1999-08-11T07:15:27-08:00</TimeCreated>
        <TimeModified>1999-08-11T07:15:27-08:00</TimeModified>
        <EditSequence>934380927</EditSequence>
        <Name>Installation</Name>
        <FullName>Installation</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>20000-999021789</ListID>
          <FullName>Non</FullName>
        </SalesTaxCodeRef>
        <SalesOrPurchase>
          <Desc>Installation of landscape design</Desc>
          <Price>35.00</Price>
          <AccountRef>
            <ListID>1F0000-934380913</ListID>
            <FullName>Landscaping Services:Labor:Installation</FullName>
          </AccountRef>
        </SalesOrPurchase>
      </ItemServiceRet>
      <ItemServiceRet>
        <ListID>40000-934380927</ListID>
        <TimeCreated>1999-08-11T07:15:27-08:00</TimeCreated>
        <TimeModified>1999-08-11T07:15:27-08:00</TimeModified>
        <EditSequence>934380927</EditSequence>
        <Name>Pest Control</Name>
        <FullName>Pest Control</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>20000-999021789</ListID>
          <FullName>Non</FullName>
        </SalesTaxCodeRef>
        <SalesOrPurchase>
          <Desc>Pest control services</Desc>
          <Price>0.00</Price>
          <AccountRef>
            <ListID>200000-934380913</ListID>
            <FullName>Landscaping Services:Labor:Maintenance &amp; Repairs</FullName>
          </AccountRef>
        </SalesOrPurchase>
      </ItemServiceRet>
      <ItemServiceRet>
        <ListID>2E0000-1071514896</ListID>
        <TimeCreated>2003-12-15T11:01:36-08:00</TimeCreated>
        <TimeModified>2003-12-15T14:42:51-08:00</TimeModified>
        <EditSequence>1071528171</EditSequence>
        <Name>Tree Removal</Name>
        <FullName>Tree Removal</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>20000-999021789</ListID>
          <FullName>Non</FullName>
        </SalesTaxCodeRef>
        <SalesOrPurchase>
          <Desc>Tree Removal Service</Desc>
          <Price>0.00</Price>
          <AccountRef>
            <ListID>610001-1071531179</ListID>
            <FullName>Service</FullName>
          </AccountRef>
        </SalesOrPurchase>
      </ItemServiceRet>
      <ItemServiceRet>
        <ListID>50000-934380927</ListID>
        <TimeCreated>1999-08-11T07:15:27-08:00</TimeCreated>
        <TimeModified>1999-08-11T07:15:27-08:00</TimeModified>
        <EditSequence>934380927</EditSequence>
        <Name>Trimming</Name>
        <FullName>Trimming</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>20000-999021789</ListID>
          <FullName>Non</FullName>
        </SalesTaxCodeRef>
        <SalesOrPurchase>
          <Desc>Tree and shrub trimming</Desc>
          <Price>35.00</Price>
          <AccountRef>
            <ListID>200000-934380913</ListID>
            <FullName>Landscaping Services:Labor:Maintenance &amp; Repairs</FullName>
          </AccountRef>
        </SalesOrPurchase>
      </ItemServiceRet>
      <ItemNonInventoryRet>
        <ListID>B0000-934380927</ListID>
        <TimeCreated>1999-08-11T07:15:27-08:00</TimeCreated>
        <TimeModified>1999-08-11T07:15:27-08:00</TimeModified>
        <EditSequence>934380927</EditSequence>
        <Name>Concrete</Name>
        <FullName>Concrete</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>10000-999021789</ListID>
          <FullName>Tax</FullName>
        </SalesTaxCodeRef>
        <SalesOrPurchase>
          <Desc>Concrete for fountain installation</Desc>
          <Price>0.00</Price>
          <AccountRef>
            <ListID>1B0000-934380913</ListID>
            <FullName>Landscaping Services:Job Materials:Fountains &amp; Garden Lighting</FullName>
          </AccountRef>
        </SalesOrPurchase>
      </ItemNonInventoryRet>
      <ItemNonInventoryRet>
        <ListID>C0000-934380927</ListID>
        <TimeCreated>1999-08-11T07:15:27-08:00</TimeCreated>
        <TimeModified>1999-08-11T07:15:27-08:00</TimeModified>
        <EditSequence>934380927</EditSequence>
        <Name>Deck Lumber</Name>
        <FullName>Deck Lumber</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>10000-999021789</ListID>
          <FullName>Tax</FullName>
        </SalesTaxCodeRef>
        <SalesOrPurchase>
          <Desc>Deck Lumber</Desc>
          <Price>0.00</Price>
          <AccountRef>
            <ListID>1A0000-934380913</ListID>
            <FullName>Landscaping Services:Job Materials:Decks &amp; Patios</FullName>
          </AccountRef>
        </SalesOrPurchase>
      </ItemNonInventoryRet>
      <ItemNonInventoryRet>
        <ListID>210000-1071530240</ListID>
        <TimeCreated>2003-12-15T15:17:20-08:00</TimeCreated>
        <TimeModified>2003-12-15T15:17:20-08:00</TimeModified>
        <EditSequence>1071530240</EditSequence>
        <Name>Fertilizer</Name>
        <FullName>Fertilizer</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>10000-999021789</ListID>
          <FullName>Tax</FullName>
        </SalesTaxCodeRef>
        <SalesOrPurchase>
          <Desc>Parent Item - Do Not Use</Desc>
          <Price>0.00</Price>
          <AccountRef>
            <ListID>600001-1071530232</ListID>
            <FullName>Retail Sales</FullName>
          </AccountRef>
        </SalesOrPurchase>
      </ItemNonInventoryRet>
      <ItemInventoryRet>
        <ListID>250000-1071523682</ListID>
        <TimeCreated>2003-12-15T13:28:02-08:00</TimeCreated>
        <TimeModified>2003-12-15T13:44:20-08:00</TimeModified>
        <EditSequence>1071524660</EditSequence>
        <Name>Irrigation Hose</Name>
        <FullName>Irrigation Hose</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>10000-999021789</ListID>
          <FullName>Tax</FullName>
        </SalesTaxCodeRef>
        <SalesDesc>Parent Item Vinyl Irrigation Line- Do Not Purchase or Sell</SalesDesc>
        <SalesPrice>0.00</SalesPrice>
        <IncomeAccountRef>
          <ListID>690001-1071523679</ListID>
          <FullName>Landscaping Services:Job Materials:Misc Materials</FullName>
        </IncomeAccountRef>
        <PurchaseDesc>Vinyl Irrigation LineParent Item - Do Not Purchase or Sell</PurchaseDesc>
        <PurchaseCost>0.00</PurchaseCost>
        <COGSAccountRef>
          <ListID>240000-934380913</ListID>
          <FullName>Cost of Goods Sold</FullName>
        </COGSAccountRef>
        <AssetAccountRef>
          <ListID>60000-934380912</ListID>
          <FullName>Inventory Asset</FullName>
        </AssetAccountRef>
        <ReorderPoint>-1</ReorderPoint>
        <QuantityOnHand>0</QuantityOnHand>
        <AverageCost>0.00</AverageCost>
        <QuantityOnOrder>0</QuantityOnOrder>
        <QuantityOnSalesOrder>0</QuantityOnSalesOrder>
      </ItemInventoryRet>
      <ItemInventoryRet>
        <ListID>270000-1071524193</ListID>
        <TimeCreated>2003-12-15T13:36:33-08:00</TimeCreated>
        <TimeModified>2003-12-15T13:38:13-08:00</TimeModified>
        <EditSequence>1071524293</EditSequence>
        <Name>1/2" Line</Name>
        <FullName>Irrigation Hose:1/2" Line</FullName>
        <IsActive>true</IsActive>
        <ParentRef>
          <ListID>250000-1071523682</ListID>
          <FullName>Irrigation Hose</FullName>
        </ParentRef>
        <Sublevel>1</Sublevel>
        <SalesTaxCodeRef>
          <ListID>10000-999021789</ListID>
          <FullName>Tax</FullName>
        </SalesTaxCodeRef>
        <SalesDesc>1/2"  Vinyl Irrigation Line</SalesDesc>
        <SalesPrice>0.15</SalesPrice>
        <IncomeAccountRef>
          <ListID>690001-1071523679</ListID>
          <FullName>Landscaping Services:Job Materials:Misc Materials</FullName>
        </IncomeAccountRef>
        <PurchaseDesc>1/2"  Vinyl Irrigation Line</PurchaseDesc>
        <PurchaseCost>0.12</PurchaseCost>
        <COGSAccountRef>
          <ListID>240000-934380913</ListID>
          <FullName>Cost of Goods Sold</FullName>
        </COGSAccountRef>
        <AssetAccountRef>
          <ListID>60000-934380912</ListID>
          <FullName>Inventory Asset</FullName>
        </AssetAccountRef>
        <ReorderPoint>1500</ReorderPoint>
        <QuantityOnHand>1783</QuantityOnHand>
        <AverageCost>0.12</AverageCost>
        <QuantityOnOrder>0</QuantityOnOrder>
        <QuantityOnSalesOrder>0</QuantityOnSalesOrder>
      </ItemInventoryRet>
      <ItemInventoryRet>
        <ListID>260000-1071523858</ListID>
        <TimeCreated>2003-12-15T13:30:58-08:00</TimeCreated>
        <TimeModified>2003-12-15T13:37:52-08:00</TimeModified>
        <EditSequence>1071524272</EditSequence>
        <Name>1/4" Line</Name>
        <FullName>Irrigation Hose:1/4" Line</FullName>
        <IsActive>true</IsActive>
        <ParentRef>
          <ListID>250000-1071523682</ListID>
          <FullName>Irrigation Hose</FullName>
        </ParentRef>
        <Sublevel>1</Sublevel>
        <SalesTaxCodeRef>
          <ListID>10000-999021789</ListID>
          <FullName>Tax</FullName>
        </SalesTaxCodeRef>
        <SalesDesc>1/4"  Vinyl Irrigation Line</SalesDesc>
        <SalesPrice>0.10</SalesPrice>
        <IncomeAccountRef>
          <ListID>690001-1071523679</ListID>
          <FullName>Landscaping Services:Job Materials:Misc Materials</FullName>
        </IncomeAccountRef>
        <PurchaseDesc>1/4"  Vinyl Irrigation Line</PurchaseDesc>
        <PurchaseCost>0.07</PurchaseCost>
        <COGSAccountRef>
          <ListID>240000-934380913</ListID>
          <FullName>Cost of Goods Sold</FullName>
        </COGSAccountRef>
        <AssetAccountRef>
          <ListID>60000-934380912</ListID>
          <FullName>Inventory Asset</FullName>
        </AssetAccountRef>
        <ReorderPoint>500</ReorderPoint>
        <QuantityOnHand>1235</QuantityOnHand>
        <AverageCost>0.07</AverageCost>
        <QuantityOnOrder>0</QuantityOnOrder>
        <QuantityOnSalesOrder>0</QuantityOnSalesOrder>
      </ItemInventoryRet>
      <ItemInventoryRet>
        <ListID>280000-1071524260</ListID>
        <TimeCreated>2003-12-15T13:37:40-08:00</TimeCreated>
        <TimeModified>2003-12-15T13:37:40-08:00</TimeModified>
        <EditSequence>1071524260</EditSequence>
        <Name>3/4" Line</Name>
        <FullName>Irrigation Hose:3/4" Line</FullName>
        <IsActive>true</IsActive>
        <ParentRef>
          <ListID>250000-1071523682</ListID>
          <FullName>Irrigation Hose</FullName>
        </ParentRef>
        <Sublevel>1</Sublevel>
        <SalesTaxCodeRef>
          <ListID>10000-999021789</ListID>
          <FullName>Tax</FullName>
        </SalesTaxCodeRef>
        <SalesDesc>3/4"  Vinyl Irrigation Line</SalesDesc>
        <SalesPrice>0.27</SalesPrice>
        <IncomeAccountRef>
          <ListID>690001-1071523679</ListID>
          <FullName>Landscaping Services:Job Materials:Misc Materials</FullName>
        </IncomeAccountRef>
        <PurchaseDesc>3/4"  Vinyl Irrigation Line</PurchaseDesc>
        <PurchaseCost>0.18</PurchaseCost>
        <COGSAccountRef>
          <ListID>240000-934380913</ListID>
          <FullName>Cost of Goods Sold</FullName>
        </COGSAccountRef>
        <AssetAccountRef>
          <ListID>60000-934380912</ListID>
          <FullName>Inventory Asset</FullName>
        </AssetAccountRef>
        <ReorderPoint>1500</ReorderPoint>
        <QuantityOnHand>2670</QuantityOnHand>
        <AverageCost>0.18</AverageCost>
        <QuantityOnOrder>0</QuantityOnOrder>
        <QuantityOnSalesOrder>0</QuantityOnSalesOrder>
      </ItemInventoryRet>
      <ItemInventoryRet>
        <ListID>60000-934380927</ListID>
        <TimeCreated>1999-08-11T07:15:27-08:00</TimeCreated>
        <TimeModified>1999-08-11T07:15:27-08:00</TimeModified>
        <EditSequence>934380927</EditSequence>
        <Name>Lighting</Name>
        <FullName>Lighting</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>10000-999021789</ListID>
          <FullName>Tax</FullName>
        </SalesTaxCodeRef>
        <SalesDesc>Garden Lighting</SalesDesc>
        <SalesPrice>0.00</SalesPrice>
        <IncomeAccountRef>
          <ListID>1B0000-934380913</ListID>
          <FullName>Landscaping Services:Job Materials:Fountains &amp; Garden Lighting</FullName>
        </IncomeAccountRef>
        <PurchaseDesc>Garden Lighting</PurchaseDesc>
        <PurchaseCost>0.00</PurchaseCost>
        <COGSAccountRef>
          <ListID>240000-934380913</ListID>
          <FullName>Cost of Goods Sold</FullName>
        </COGSAccountRef>
        <AssetAccountRef>
          <ListID>60000-934380912</ListID>
          <FullName>Inventory Asset</FullName>
        </AssetAccountRef>
        <QuantityOnHand>94</QuantityOnHand>
        <AverageCost>14.80</AverageCost>
        <QuantityOnOrder>28</QuantityOnOrder>
        <QuantityOnSalesOrder>0</QuantityOnSalesOrder>
      </ItemInventoryRet>
      <ItemInventoryRet>
        <ListID>70000-934380927</ListID>
        <TimeCreated>1999-08-11T07:15:27-08:00</TimeCreated>
        <TimeModified>1999-08-11T07:15:27-08:00</TimeModified>
        <EditSequence>934380927</EditSequence>
        <Name>Pump</Name>
        <FullName>Pump</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>10000-999021789</ListID>
          <FullName>Tax</FullName>
        </SalesTaxCodeRef>
        <SalesDesc>Fountain pump</SalesDesc>
        <SalesPrice>75.00</SalesPrice>
        <IncomeAccountRef>
          <ListID>1B0000-934380913</ListID>
          <FullName>Landscaping Services:Job Materials:Fountains &amp; Garden Lighting</FullName>
        </IncomeAccountRef>
        <PurchaseDesc>Fountain pump #198-30</PurchaseDesc>
        <PurchaseCost>56.00</PurchaseCost>
        <COGSAccountRef>
          <ListID>240000-934380913</ListID>
          <FullName>Cost of Goods Sold</FullName>
        </COGSAccountRef>
        <AssetAccountRef>
          <ListID>60000-934380912</ListID>
          <FullName>Inventory Asset</FullName>
        </AssetAccountRef>
        <QuantityOnHand>48</QuantityOnHand>
        <AverageCost>53.93</AverageCost>
        <QuantityOnOrder>0</QuantityOnOrder>
        <QuantityOnSalesOrder>0</QuantityOnSalesOrder>
      </ItemInventoryRet>
      <ItemInventoryRet>
        <ListID>80000-934380927</ListID>
        <TimeCreated>1999-08-11T07:15:27-08:00</TimeCreated>
        <TimeModified>1999-08-11T07:15:27-08:00</TimeModified>
        <EditSequence>934380927</EditSequence>
        <Name>Soil</Name>
        <FullName>Soil</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>10000-999021789</ListID>
          <FullName>Tax</FullName>
        </SalesTaxCodeRef>
        <SalesDesc>Soil, 2 cubic ft bag</SalesDesc>
        <SalesPrice>6.75</SalesPrice>
        <IncomeAccountRef>
          <ListID>1C0000-934380913</ListID>
          <FullName>Landscaping Services:Job Materials:Plants and Sod</FullName>
        </IncomeAccountRef>
        <PurchaseDesc>Soil, 2 cubic ft bag</PurchaseDesc>
        <PurchaseCost>5.30</PurchaseCost>
        <COGSAccountRef>
          <ListID>240000-934380913</ListID>
          <FullName>Cost of Goods Sold</FullName>
        </COGSAccountRef>
        <PrefVendorRef>
          <ListID>10000-934380927</ListID>
          <FullName>Middlefield Nursery</FullName>
        </PrefVendorRef>
        <AssetAccountRef>
          <ListID>60000-934380912</ListID>
          <FullName>Inventory Asset</FullName>
        </AssetAccountRef>
        <ReorderPoint>25</ReorderPoint>
        <QuantityOnHand>0</QuantityOnHand>
        <AverageCost>5.30</AverageCost>
        <QuantityOnOrder>6</QuantityOnOrder>
        <QuantityOnSalesOrder>10</QuantityOnSalesOrder>
      </ItemInventoryRet>
      <ItemInventoryRet>
        <ListID>90000-934380927</ListID>
        <TimeCreated>1999-08-11T07:15:27-08:00</TimeCreated>
        <TimeModified>1999-08-11T07:15:27-08:00</TimeModified>
        <EditSequence>934380927</EditSequence>
        <Name>Sprinkler Hds</Name>
        <FullName>Sprinkler Hds</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>10000-999021789</ListID>
          <FullName>Tax</FullName>
        </SalesTaxCodeRef>
        <SalesDesc>Sprinkler heads</SalesDesc>
        <SalesPrice>0.00</SalesPrice>
        <IncomeAccountRef>
          <ListID>1D0000-934380913</ListID>
          <FullName>Landscaping Services:Job Materials:Sprinklers &amp; Drip systems</FullName>
        </IncomeAccountRef>
        <PurchaseDesc>Sprinkler head #BLS9081-09</PurchaseDesc>
        <PurchaseCost>0.00</PurchaseCost>
        <COGSAccountRef>
          <ListID>240000-934380913</ListID>
          <FullName>Cost of Goods Sold</FullName>
        </COGSAccountRef>
        <AssetAccountRef>
          <ListID>60000-934380912</ListID>
          <FullName>Inventory Asset</FullName>
        </AssetAccountRef>
        <QuantityOnHand>69</QuantityOnHand>
        <AverageCost>6.38</AverageCost>
        <QuantityOnOrder>36</QuantityOnOrder>
        <QuantityOnSalesOrder>0</QuantityOnSalesOrder>
      </ItemInventoryRet>
      <ItemInventoryRet>
        <ListID>A0000-934380927</ListID>
        <TimeCreated>1999-08-11T07:15:27-08:00</TimeCreated>
        <TimeModified>1999-08-11T07:15:27-08:00</TimeModified>
        <EditSequence>934380927</EditSequence>
        <Name>Sprkl pipes</Name>
        <FullName>Sprkl pipes</FullName>
        <IsActive>true</IsActive>
        <Sublevel>0</Sublevel>
        <SalesTaxCodeRef>
          <ListID>10000-999021789</ListID>
          <FullName>Tax</FullName>
        </SalesTaxCodeRef>
        <SalesDesc>Plastic sprinkler piping</SalesDesc>
        <SalesPrice>2.75</SalesPrice>
        <IncomeAccountRef>
          <ListID>1D0000-934380913</ListID>
          <FullName>Landscaping Services:Job Materials:Sprinklers &amp; Drip systems</FullName>
        </IncomeAccountRef>
        <PurchaseDesc>Plastic sprinkler piping #1098-20</PurchaseDesc>
        <PurchaseCost>2.10</PurchaseCost>
        <COGSAccountRef>
          <ListID>240000-934380913</ListID>
          <FullName>Cost of Goods Sold</FullName>
        </COGSAccountRef>
        <AssetAccountRef>
          <ListID>60000-934380912</ListID>
          <FullName>Inventory Asset</FullName>
        </AssetAccountRef>
        <ReorderPoint>250</ReorderPoint>
        <QuantityOnHand>826</QuantityOnHand>
        <AverageCost>2.10</AverageCost>
        <QuantityOnOrder>115</QuantityOnOrder>
        <QuantityOnSalesOrder>0</QuantityOnSalesOrder>
      </ItemInventoryRet>
    </ItemQueryRs>
  </QBXMLMsgsRs>
</QBXML>